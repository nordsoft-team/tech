#!/bin/bash
ps -ef | grep 'git/springCloud' |grep -v 'grep' | awk '{print $2}' |xargs kill