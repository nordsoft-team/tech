#!/bin/bash
expect << EOF
spawn ssh $1

expect "password:"
send "$2\r"

expect "~*"
send "pwd\r"

send  "exit\r"
expect eof
EOF
pwd