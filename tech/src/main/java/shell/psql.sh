#!/bin/bash
export PGPASSWORD="panatripdev"
function abc(){
	psql -h 192.168.1.12 -p 5432 -d biqu -U dev<<EOF
	select * from test_wlh_dom_cache_analysis offset (select count(*) from test_wlh_dom_cache_analysis)-7;
	\q
EOF
}
abc | grep 2017 | awk 'gsub(/\|/,"\t")';