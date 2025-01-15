#!/bin/bash

if [ ! -d "./runs" ]; then
    mkdir runs
fi

docker run -it --rm \
-v ./runs:/ultralytics/runs \
-p 6006:6006 \
registry.cn-hangzhou.aliyuncs.com/hexchip/ultralytics:8.3.40 \
tensorboard --logdir /ultralytics/runs --bind_all