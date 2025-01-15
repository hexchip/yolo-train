#!/bin/bash

set -e

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Run YOLO video inference with Docker container."
    echo
    echo "Options:"
    echo "  --modelName             Model file name in ./models directory (default: best.pt)"
    echo "  --videoName             Video file name in ./sources/videos directory (default: test.mp4)"
    echo "  --enable-nvidia-gpu     Exposing nvidia gpu to container, default: Flase"
    echo "  --help                  Show this help message"
    echo
    echo "Example:"
    echo "  $0 --modelName best.pt --videoName demo.mp4"
    echo
    echo "Note: Make sure files exist in corresponding directories before running."
}

modelName="best.pt"
videoName="test.mp4"

is_enable_nvidia_gpu=0

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --modelName)
            [[ -z "$2" ]] && echo "Error: --modelName requires a value" >&2 && usage >&2 && exit 1
            modelName="$2"
            shift 
            ;;
        --videoName)
            [[ -z "$2" ]] && echo "Error: --videoName requires a value" >&2 && usage >&2 && exit 1
            videoName="$2"
            shift 
            ;;
        --enable-nvidia-gpu)
            is_enable_nvidia_gpu=1;
            shift 
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown parameter passed: $1" >&2
            usage >&2
            exit 1 
            ;;
    esac
    shift
done

if [ ! -d "./runs" ]; then
    mkdir runs
fi

if [ ! -d "./models" ]; then
    mkdir models
fi

if [ ! -d "./sources/videos" ]; then
    mkdir -p sources/videos
fi

docker_gpu_arg=""

if (( is_enable_nvidia_gpu == 1 )); then
    docker_gpu_arg="--gpus all"
fi

docker run -it --rm --pull always \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /mnt/wslg:/mnt/wslg \
-v /usr/lib/wsl:/usr/lib/wsl \
--device /dev/dxg \
--device /dev/dri \
-e DISPLAY=$DISPLAY \
-e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-e PULSE_SERVER=$PULSE_SERVER \
${docker_gpu_arg} \
-v ./runs:/ultralytics/runs:ro \
-v ./models:/ultralytics/models:ro \
-v ./sources/videos:/ultralytics/videos:ro \
registry.cn-hangzhou.aliyuncs.com/hexchip/ultralytics-yolo-infer-video \
--modelPath ./models/${modelName} \
--videoPath ./videos/${videoName}
