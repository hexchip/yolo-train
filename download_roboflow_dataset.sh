#!/bin/bash

set -e

datasetUrl="hexchip/-7xvt9/7"
datasetFormat="yolov11"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --datasetUrl) datasetUrl="$2"; shift ;;
        --datasetFormat) datasetFormat="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ ! -d "./datasets" ]; then
    mkdir datasets
fi

docker run -it --rm \
-v ~/.config/roboflow:/root/.config/roboflow \
-v ./datasets:/datasets \
registry.cn-hangzhou.aliyuncs.com/hexchip/roboflow-downloader:latest \
--datasetUrl "$datasetUrl" \
--datasetFormat "$datasetFormat"