#!/bin/bash
expect << EOF
spawn ssh root@39.106.3.97

expect "password:"
send "Abcd1234\r"

expect "~*"
send "pwd\r"

send  "exit\r"
expect eof
EOF
ls