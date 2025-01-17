#!/bin/bash

set -e

modelName="best.pt"
videoName="test.mp4"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --modelName) modelName="$2"; shift ;;
        --videoName) videoName="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ ! -d "./models" ]; then
    mkdir models
fi

if [ ! -d "./videos" ]; then
    mkdir videos
fi

docker run -it --rm \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /mnt/wslg:/mnt/wslg \
-v /usr/lib/wsl:/usr/lib/wsl \
--device /dev/dxg \
--device /dev/dri/card0 \
--device /dev/dri/renderD128 \
-e DISPLAY=$DISPLAY \
-e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-e PULSE_SERVER=$PULSE_SERVER \
--ipc=host \
--gpus all \
-v ./runs:/ultralytics/runs \
-v ./models:/ultralytics/models \
-v ./videos:/ultralytics/videos \
registry.cn-hangzhou.aliyuncs.com/hexchip/yolo_infer_video:latest \
--modelPath ./models/${modelName} \
--videoPath ./videos/${videoName}
