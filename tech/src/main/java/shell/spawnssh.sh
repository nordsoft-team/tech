#!/usr/bin/expect
set user [lindex $argv 0]
set ip [lindex $argv 1]
set pass [lindex $argv 2]
spawn ssh $user@$ip
expect {
	"yes/no" { send "yes\r"; exp_continue}
	"password:" { send "$pass\r" }
}
interact