#!/bin/bash

DEBUG=false
# DEBUG=true
function DEBUG() {
    if [ "$DEBUG" = "true" ]; then
        $@
    fi
}