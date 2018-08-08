#!/bin/bash

apt update
echo y| apt install openjdk-9-jdk

echo 'export JAVA_HOME=/usr/lib/jvm/java-9-openjdk-amd64'>>~/.bashrc
echo 'export CLASSPATH=${JAVA_HOME}/lib'>>~/.bashrc
echo 'export PATH=${JAVA_HOME}/bin:$PATH'>>~/.bashrc
source ~/.bashrc