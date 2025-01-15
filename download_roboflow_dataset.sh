#!/bin/bash

datasetUrl="hexchip/-7xvt9/1"
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

# 执行 Docker 命令
docker run -it --rm \
  -v ~/.config/roboflow:/root/.config/roboflow \
  -v ./datasets:/datasets \
  registry.cn-hangzhou.aliyuncs.com/hexchip/roboflow-downloader:latest \
  --datasetUrl "$datasetUrl" \
  --datasetFormat "$datasetFormat"