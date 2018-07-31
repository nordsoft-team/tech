#!/bin/bash

cd /Users/fanfei/Dev/elk

echo "Start"

echo "go to process elasticsearch"
elasticsearch-5.4.1/bin/elasticsearch >/dev/null 2>&1 &

echo "go to process logstash"
logstash-5.4.1/bin/logstash -f logstash-5.4.1/config/logstash.conf >/dev/null 2>&1 &

echo "go to process kibana"
kibana-5.4.1-darwin-x86_64/bin/kibana >/dev/null 2>&1 &

echo "Done"