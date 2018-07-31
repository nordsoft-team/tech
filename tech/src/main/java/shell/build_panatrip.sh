#!/bin/bash

DEBUG=false
# DEBUG=true
function DEBUG() {
    if [ "$DEBUG" = "true" ]; then
        $@
    fi
}
function EXEC() {
    if [ "$DEBUG" = "false" ]; then
        $@
    fi
}

# Print message $2 with log-level $1 to STDERR, colorized if terminal
LOG() {
    local level=${1?}
    shift
    local code= date="$(date '+%F %T')" msg="$*"
    if [ -t 2 ]; then
        case "$level" in
            INFO) code=36 ;;
            DEBUG) code=30 ;;
            WARN) code=33 ;;
            ERROR) code=31 ;;
            *) code=37 ;;
        esac
        echo -e "${date} \e[${code}m[${level}]\e[0m: ${msg}"
    else
        echo "$date [$level]: $msg"
    fi >&2
}

DEBUG LOG "DEBUG" "DEBUG Mode: on"

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
BUILD_DIR=`cd "$PRGDIR/" >/dev/null; pwd`

cd $BUILD_DIR
for i in ./profile.d/*.project ; do
    if [ -r "$i" ]; then
        . "$i"
    fi
done

# 处理参数
ARGS=`getopt -o "mdRp:r:n:BX" -l "make,deploy,release,profile:,revision:,number:,backup,debug" -n "build_panatrip" -- "$@"`
eval set -- "${ARGS}"

# hostname
host_id="$(hostname -s)"

# 进程标识
proc_id=$host_id

make_flag=false
deploy_flag=false
branch=$DEFAULT_BRANCH
profile=$DEFAULT_PROFILE
revision="HEAD"
number_of_instances=1
backup_flag=false

while true; do
    case "${1}" in
        -m|--make)
            shift;
            make_flag=true
            echo -e "Make flag: ON"
            ;;
        -d|--deploy)
            shift;
            deploy_flag=true
            echo -e "Deploy flag: ON"
            ;;
        -R|--release)
            shift;
            branch="release"
            echo -e "Release flag: ON"
            ;;
        -p|--profile)
            shift;
            if [[ -n "${1}" ]]; then
                profile="${1}"
                echo -e "Profile: assigned, value is ${1}"
                shift;
            fi
            ;;
        -r|--revision)
            shift;
            if [[ -n "${1}" ]]; then
                revision="${1}"
                echo -e "Revision: assigned, value is ${1}"
                shift;
            fi
            ;;
        -n|--number)
            shift;
            if [[ ${1} == ?(-)+([0-9]) && ${1} -ge 1 ]]; then
                number_of_instances=${1}
                echo -e "Number of instances: assigned, value is ${1}"
                shift;
            fi
            ;;
        -B|--backup)
            shift;
            backup_flag=true
            echo -e "Backup flag: ON"
            ;;
        -X|--debug)
            shift;
            DEBUG=true
            echo -e "Debug flag: ON"
            ;;
        --)
            shift;
            break;
            ;;
    esac
done

# 默认为 make
if [[ "$make_flag" == "false" && "$deploy_flag" == "false" ]]; then
    make_flag=true
fi


function func_switchProject() {
    local project=$1
    local -u mark
    mark="$project"_"$branch"

    project_name="${PROJECT_NAME[${mark}]}"
    artifact_id="${ARTIFACT_ID[${mark}]}"
    packaging="${PACKAGING[${mark}]}"
    multi_module="${MULTI_MODULE[${mark}]}"
    parent_project="${PARENT_PROJECT[${mark}]}"
    dependencies="${DEPENDENCIES[${mark}]}"
    deployable="${DEPLOYABLE[${mark}]}"
    src_dir="${SRC_DIR[${mark}]}"
    run_dir="${RUN_DIR[${mark}]}"
    server_dirs="${SERVER_DIRS[${mark}]}"
    server_context_path="${SERVER_CONTEXT_PATH[${mark}]}"
    server_java_opts="${SERVER_JAVA_OPTS[${mark}]}"
    server_opts="${SERVER_OPTS[${mark}]}"


    if [[ "$packaging" == "pom" ]]; then
        archive_file_mark="${src_dir}/pom.xml"
        archive_file="${src_dir}/pom.xml"
    else
        # jar or war
        if [[ "$packaging" == "jar" && "$deployable" == "true" ]]; then
            # 实际用来执行的文件
            run_file_mark="${run_dir}/${artifact_id}"
            run_file_original="${run_file_mark}-${branch}.${packaging}"
            run_file_backup="${run_file_original}.backup"
            run_file="${run_file_mark}-${branch}_${host_id}.${packaging}"
        else
            packaging="war"
        fi
        # 打包生成的文件
        archive_file_mark="${src_dir}/target/${artifact_id}"
        archive_file_pattern="${archive_file_mark}-*.${packaging}"
    fi

    banner="$project_name - $branch"

    # echo "Project Name: ${project_name}"
    # echo "Artifact ID: ${artifact_id}"
    # echo "Multi-module: ${multi_module}"
    # echo "Parent Project: ${parent_project}"
    # echo "Dependencies: ${dependencies}"
    # echo "Deployable: ${deployable}"
    # echo "Src Dir: ${src_dir}"
    # echo "Run Dir: ${run_dir}"
    # echo "Server Dirs: ${server_dirs}"
    # echo "Server Context Path: ${server_context_path}"
    # echo "Packaging: ${packaging}"
}

# 更新单个项目
function func_updateSingleProject() {
    local project=$1
    local is_dependency=$2
    func_switchProject "$project"

    DEBUG LOG "DEBUG" "EXEC: cd $src_dir"
    EXEC cd $src_dir
    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Updating $banner"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""

    if [[ "$revision" == "HEAD" ]]; then
        # svn update
        DEBUG LOG "DEBUG" "EXEC: svn update $src_dir"
        EXEC svn update $src_dir
    else
        # svn update -r $revision
        DEBUG LOG "DEBUG" "EXEC: svn update -r $revision $src_dir"
        EXEC svn update -r $revision $src_dir
    fi

    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Updated $banner"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""
}

function func_makeProject() {
    local project=$1
    local projects_list=$2
    func_switchProject "$project"

    DEBUG LOG "DEBUG" "EXEC: cd $src_dir"
    EXEC cd $src_dir
    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Making $banner"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""

    if [[ -z "$projects_list" ]]; then
        # mvn clean package -DskipTests -Denv=XXX
        DEBUG LOG "DEBUG" "EXEC: mvn clean package -DskipTests -Denv=$P_ENV"
        EXEC mvn clean package -DskipTests -Denv=$P_ENV
    else
        DEBUG LOG "DEBUG" "EXEC: mvn clean package -pl $projects_list -am -DskipTests -Denv=$P_ENV"
        EXEC mvn clean package -pl $projects_list -am -DskipTests -Denv=$P_ENV
    fi

    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Made $banner"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""
}

function func_stopService() {
    local service_mark=$1

    if pkill -0 -f "java.*$service_mark"; then
        DEBUG LOG "DEBUG" "Check: $artifact_id is running"
        DEBUG LOG "DEBUG" "EXEC: pkill -SIGTERM -f \"java.*$service_mark\""
        EXEC pkill -SIGTERM -f "java.*$service_mark"
        DEBUG LOG "DEBUG" "EXEC: sleep 2s"
        EXEC sleep 2s

        local attempts=0
        while pkill -0 -f "java.*$service_mark"; do
            attempts=$[$attempts + 1]
            LOG "INFO" "Check: still running. +$attempts"
            if [[ $attempts -ge 10 ]]; then
                # We have waited too long. Kill it.
                DEBUG LOG "DEBUG" "EXEC: pkill -9 -f \"java.*$service_mark\""
                EXEC pkill -9 -f "java.*$service_mark"
                LOG "INFO" "Killed"
                break
            fi
            EXEC sleep 2s
        done
    else
        DEBUG LOG "DEBUG" "Check: $artifact_id is not running"
    fi
}

function func_deploySingleProject() {
    local project=$1
    func_switchProject "$project"

    if [[ "$artifact_id" != "biqu-bee" ]]; then
        number_of_instances=1
    fi
    local noi=$number_of_instances

    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Deploying $banner"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""
    archive_file="$(echo $archive_file_pattern)"
    DEBUG LOG "DEBUG" "archive_file: $archive_file"
    DEBUG LOG "DEBUG" "run_file_original: $run_file_original"
    DEBUG LOG "DEBUG" "run_file_backup: $run_file_backup"
    DEBUG LOG "DEBUG" "run_file: $run_file"

    # 设置当前用户的最大文件数限制
    ulimit -n 65536

    if [[ "$packaging" == "jar" ]]; then
        if [[ ! -d "$run_dir" ]]; then
            DEBUG LOG "DEBUG" "EXEC: mkdir -p $run_dir"
            EXEC mkdir -p $run_dir
        fi
        DEBUG LOG "DEBUG" "EXEC: cd $run_dir"
        EXEC cd $run_dir
        # 停止已运行的服务
        func_stopService "$run_file_mark"
        # 拷贝 jar 文件至执行目录
        if [[ "$backup_flag" == "false" ]]; then
            # 备份
            if [[ -f "$run_file_original" && ( ! -f "$run_file_backup" || $archive_file -nt $run_file_original ) ]]; then
                LOG "INFO" "Backup archive: $run_file_backup"

                DEBUG LOG "DEBUG" "EXEC: cp -pu $run_file_original $run_file_backup"
                EXEC cp -pu $run_file_original $run_file_backup
            fi
            DEBUG LOG "DEBUG" "EXEC: cp -pu $archive_file $run_file_original"
            EXEC cp -pu $archive_file $run_file_original
        else
            if [[ -f "$run_file_backup" ]]; then
                LOG "INFO" "Using backup archive: $run_file_backup"

                DEBUG LOG "DEBUG" "EXEC: cp -p $run_file_backup $run_file_original"
                EXEC cp -p $run_file_backup $run_file_original
            fi
        fi
        # 启动服务
        DEBUG LOG "DEBUG" "EXEC: cp -p $run_file_original $run_file"
        EXEC cp -p $run_file_original $run_file
        # 指定激活的 profile
        local space_or_not;
        [[ -n "$server_opts" ]] && space_or_not=" "
        server_opts="--spring.profiles.active=${profile}${space_or_not}${server_opts}"
        DEBUG LOG "DEBUG" "server_opts: $server_opts"
        # nohup java $server_java_opts -jar $run_file $server_opts &
        local startup_cmd="java $server_java_opts -jar $run_file $server_opts"
        local console_output_file="${run_dir}/${artifact_id}_${proc_id}.out"
        for i in $(seq 1 $noi); do
            DEBUG LOG "DEBUG" "EXEC: nohup $startup_cmd > $console_output_file 2>&1 &"
            if [ "$DEBUG" = "false" ]; then
                nohup $startup_cmd > $console_output_file 2>&1 &
            fi
        done

        LOG "INFO" "Log file: $console_output_file"
    else
        if [[ -n "$server_dirs" ]]; then
            while IFS=',' read -ra ADDR; do
                for server_dir in "${ADDR[@]}"; do
                    LOG "INFO" "Deploying to: $server_dir"
                    if [[ ! -d "$server_dir" ]]; then
                        DEBUG LOG "WARN" "Server '$server_dir' doesn't exist, skip.."
                        continue
                    fi

                    local context_path="ROOT"
                    if [[ -n "$server_context_path" ]]; then
                        context_path="$server_context_path"
                    fi

                    DEBUG LOG "DEBUG" "EXEC: cd $server_dir/bin/"
                    EXEC cd $server_dir/bin/
                    DEBUG LOG "DEBUG" "EXEC: ./shutdown.sh"
                    EXEC ./shutdown.sh

                    DEBUG LOG "DEBUG" "EXEC: rm -rf $server_dir/webapps/$context_path.war"
                    EXEC rm -rf $server_dir/webapps/$context_path.war
                    DEBUG LOG "DEBUG" "EXEC: rm -rf $server_dir/webapps/$context_path"
                    EXEC rm -rf $server_dir/webapps/$context_path
                    DEBUG LOG "DEBUG" "EXEC: cp -p $archive_file $server_dir/webapps/$context_path.war"
                    EXEC cp -p $archive_file $server_dir/webapps/$context_path.war

                    DEBUG LOG "DEBUG" "EXEC: ./startup.sh"
                    EXEC ./startup.sh
                    DEBUG LOG "DEBUG" "EXEC: sleep 5"
                    EXEC sleep 5
                    var_time=`date "+%Y-%m-%d--%H:%M"`
                    DEBUG LOG "DEBUG" "EXEC: echo \"Deploy time: $var_time\" > $server_dir/webapps/$context_path/v.html"
                    if [ "$DEBUG" = "false" ]; then
                        echo "Deploy time: $var_time" > $server_dir/webapps/$context_path/v.html
                    fi

                    DEBUG LOG "DEBUG" "$server_dir/webapps/$context_path.war"

                    LOG "INFO" "Log file: $server_dir/logs/catalina.out"
                done
            done <<< "$server_dirs"
        fi
    fi

    local str_instance=$([ "$number_of_instances" -gt 1 ] && echo "Instances" || echo "Instance")
    LOG "INFO" ""
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" "Deployed $banner   / $number_of_instances $str_instance"
    LOG "INFO" "------------------------------------------------------------------------"
    LOG "INFO" ""
}

function func_updateMultiProject() {
    local project=$1
    func_switchProject "$project"

    func_updateSingleProject "$project"
    if [[ -n "$dependencies" ]]; then
        # 更新依赖的项目
        LOG "INFO" "Updating dependencies.."
        while IFS=',' read -ra ADDR; do
            for dProject in "${ADDR[@]}"; do
                LOG "INFO" "Updating dependency: $dProject"
                # 切换当前 project 环境变量
                func_switchProject "$dProject"
                func_updateSingleProject "$dProject" true
            done
        done <<< "$dependencies"
    fi

    # 切换回当前 project
    func_switchProject "$project"
}


declare -a single_module_projects
declare -A multi_module_projects

# 将参数转换为小写并去除重复
new_args=( $(printf "%s\n" "${@,,}" | sort -u) )
DEBUG LOG "DEBUG" "Before: $@"
DEBUG LOG "DEBUG" "After: ${new_args[@]}"
echo -e ""

for project in "${new_args[@]}"; do
    # 切换当前 project 环境变量
    func_switchProject "$project"

    # 检查项目是否存在
    if [[ -z "$src_dir" || ! -d "$src_dir" ]]; then
        DEBUG LOG "WARN" "Project '$project - $branch' doesn't exist, skip.."
        echo -e ""
        continue
    fi

    # 将 project 按单模块和多模块分类
    if [[ "$multi_module" == "false" ]]; then
        single_module_projects+=("$project")
    else
        if [[ -z "$parent_project" ]]; then
            mKey="$project"
        else
            mKey="$parent_project"
        fi

        # 将 parent module 放在开头
        if [[ -z "$parent_project" ]]; then
            multi_module_projects[$mKey]="$project "${multi_module_projects[$mKey]}
        else
            multi_module_projects[$mKey]+=" $project"
        fi
    fi

done

# 单模块项目
# ======================================================================================
DEBUG LOG "DEBUG" "Single Projects: ${single_module_projects[@]}"
for sProject in "${single_module_projects[@]}"; do
    func_switchProject "$sProject"
    DEBUG LOG "DEBUG" "Single: $sProject"

    if [[ "$make_flag" == "true" ]]; then
        # 更新
        func_updateSingleProject "$sProject"

        # 构建
        func_makeProject "$sProject"
    fi

    # 部署
    if [[ "$deploy_flag" == "true" ]]; then
        func_deploySingleProject "$sProject"
    fi

    echo -e ""
done
echo -e ""


declare -A m_parent_project
declare -A m_children_projects
declare -A m_projects_list

# 多模块项目
# ======================================================================================
for key in "${!multi_module_projects[@]}"; do
    idx=0
    for mProject in ${multi_module_projects[$key]}; do
        func_switchProject "$mProject"

        # 检测是否含有 parent project
        if [[ $idx -eq 0 && -z "$parent_project" ]]; then
            m_parent_project[$key]="$mProject"
        fi

        if [[ -z "${m_parent_project[$key]}" || $idx -ne 0 ]]; then
            if [[ -z "${m_projects_list[$key]}" ]]; then
                m_children_projects[$key]="$mProject"
                m_projects_list[$key]="$artifact_id"
            else
                m_children_projects[$key]+=" $mProject"
                m_projects_list[$key]+=",$artifact_id"
            fi
        fi
        let idx++
    done
done

for key in "${!multi_module_projects[@]}"; do
    DEBUG LOG "DEBUG" "Multi-module Projects: $key - ${multi_module_projects[$key]}"
    DEBUG LOG "DEBUG" "Children Projects: ${m_children_projects[$key]}"
    DEBUG LOG "DEBUG" "Projects list: ${m_projects_list[$key]}"
    if [[ "$make_flag" == "true" ]]; then
         # 更新
        if [[ -n "${m_parent_project[$key]}" ]]; then
            func_updateSingleProject "${m_parent_project[$key]}"
        else
            for mProject in ${m_children_projects[$key]}; do
                func_updateMultiProject "$mProject"
            done
        fi

        # 构建
        if [[ -n "${m_parent_project[$key]}" ]]; then
            func_makeProject "${m_parent_project[$key]}"
        else
            func_makeProject "$key" "${m_projects_list[$key]}"
        fi
    fi

    # 部署
    if [[ "$deploy_flag" == "true" ]]; then
        for mProject in ${m_children_projects[$key]}; do
            func_deploySingleProject "$mProject"
        done
    fi

    echo -e ""
done