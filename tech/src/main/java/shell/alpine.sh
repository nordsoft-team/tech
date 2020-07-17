#!/usr/bin/expect
if {[file exists ~/.ssh/known_hosts]} {
    file delete [glob ~/.ssh/known_hosts]
}
set timeout 5
set dwp "alpine\r"

spawn ssh -p 2222 root@localhost

expect {
    "yes/no" {
        send "yes\n"
        expect "password:"
        send "$dwp\n"
    }

    "*password:*" {
        send "$dwp\n"
    }
}
expect "*#"
send "mount -o rw,union,update /\r"
expect "*#"
send "cd /var/containers/Data/System/\r"
expect "*#"
send "echo hello\r"
send "mkdir -p /Users/admin/Desktop/bak/\r"
send "dir=\$(find . -name 'internal'| cut -d '/' -f 2)\n cp -rv /var/containers/Data/System/\$dir/Library/activation_records /\r"
expect "*#"
spawn scp -r -P 2222 "root@localhost:/var/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist"  "/Users/admin/Desktop/bak/"
expect {
    "*password:*" { send $dwp\r;interact }
}

spawn scp -r -P 2222 "root@localhost:/activation_records" "/Users/admin/Desktop/bak/"
expect {
    "*password:*" { send $dwp\r;interact }
}

spawn scp -r -P 2222 "root@localhost:/var/mobile/Library/FairPlay/" "/Users/admin/Desktop/bak/"
expect {
    "*password:*" { send $dwp\r;interact }
}