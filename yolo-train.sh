#!/bin/bash

set -e

task="detect"
datasetName="CLD-TEST3-7"
yolo_extra_args=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --task) task="$2"; shift ;;
        --datasetName) datasetName="$2"; shift ;;
        # 将未识别的参数添加到 yolo_extra_args 数组中
        *) yolo_extra_args+=("$1") ;;
    esac
    shift
done

docker run -it --rm \
--ipc=host \
--gpus all \
-v ./datasets:/datasets \
-v ./runs:/ultralytics/runs \
ultralytics/ultralytics \
yolo ${task} train data=/datasets/${datasetName}/data.yaml ${yolo_extra_args[@]}