#!/bin/bash

function _ping() {
    curl --silent 127.0.0.1:8001/api/v1/namespaces/intruder/services/app-v1:80/proxy/
}

while true
do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $(_ping)"
    sleep 1s
done