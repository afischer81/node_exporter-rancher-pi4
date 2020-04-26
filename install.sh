#!/bin/bash

IMAGE=node_exporter/aarch64

function do_build {
    docker build -t ${IMAGE} .
}

function do_run {
    docker run -d -p 9100:9100 \
        -v "/proc:/host/proc:ro" \
        -v "/sys:/host/sys:ro" \
        -v "/:/rootfs:ro" \
        -v "/mnt/docker:/dockerfs:ro" \
        -v "/mnt/opt:/optfs:ro" \
        --net="host" \
        --name="node_exporter" \
        --restart unless-stopped \
        ${IMAGE} \
        --path.procfs /host/proc \
        --path.sysfs /host/sys \
        --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" 
}

task=$1
shift
do_$task $*

