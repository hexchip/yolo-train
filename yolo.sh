#!/bin/bash

set -e

usage() {
    echo "Usage: $0 [options] [YOLO_args]"
    echo
    echo "Options:"
    echo "  --task                  Specify the task to run (detect, segment, etc.), default: detect"
    echo "  --mode                  Set the mode (train, val, predict, etc.), default: train"
    echo "  --enable-nvidia-gpu     Exposing nvidia gpu to container, default: Flase"
    echo "  -h, --help              Display this help message"
    echo
    echo "YOLO_args:"
    echo "  Please reference https://docs.ultralytics.com/modes/"
    echo "  YOLO_args will be passed directly to the YOLO CLI."
    echo
    echo "Please place the dataset in the ./datasets, the model in the ./models, and the images or videos in the ./sources."
    echo "The running results will be stored in the ./run."
    echo
    echo "Example:"
    echo "  $0 --task detect --mode train model=models/best.pt data=datasets/Honor-of-Kings-1/data.yaml imgsz=800 epochs=50"
    echo
}

task="detect"
mode="train"
yolo_args=()

is_enable_nvidia_gpu=0

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        --task)
            [[ -z "$2" ]] && echo "Error: --task requires a value" >&2 && usage >&2 && exit 1
            task="$2"; 
            shift 
            ;;
        --mode) 
            [[ -z "$2" ]] && echo "Error: --mode requires a value" >&2 && usage >&2 && exit 1
            mode="$2"; 
            shift 
            ;;
        --enable-nvidia-gpu)
            is_enable_nvidia_gpu=1;
            shift 
            ;;
        *)
            yolo_args+=("$1") 
            ;;
    esac
    shift
done

set_default_args() {
    case "$mode" in
        train)
            yolo_args+=("data=Honor-of-Kings-1/data.yaml")
            yolo_args+=("imgsz=800")
            ;;
    esac
}

if [ ${#yolo_args[@]} -eq 0 ]; then
    set_default_args
fi

if [ ! -d "./tmp" ]; then
    mkdir tmp
fi

if [ ! -d "./datasets" ]; then
    mkdir datasets
fi

if [ ! -d "./sources/images" ]; then
    mkdir -p sources/images
fi

if [ ! -d "./sources/videos" ]; then
    mkdir -p sources/videos
fi

if [ ! -d "./runs" ]; then
    mkdir runs
fi

if [ ! -d "./models" ]; then
    mkdir models
fi

docker_gpu_arg=""

if (( is_enable_nvidia_gpu == 1 )); then
    docker_gpu_arg="--gpus all"
fi

docker run -it --rm \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /mnt/wslg:/mnt/wslg \
-v /usr/lib/wsl:/usr/lib/wsl \
--device /dev/dxg \
--device /dev/dri \
-e DISPLAY=$DISPLAY \
-e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-e PULSE_SERVER=$PULSE_SERVER \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro \
-v ./tmp:/home/$(whoami) \
--user $(id -u):$(id -g) \
${docker_gpu_arg} \
--ipc=host \
-v ./datasets:/ultralytics/ultralytics/datasets \
-v ./sources:/ultralytics/sources:ro \
-v ./runs:/ultralytics/runs \
-v ./models:/ultralytics/models:ro \
registry.cn-hangzhou.aliyuncs.com/hexchip/ultralytics:8.3.40 \
yolo ${task} ${mode} ${yolo_args[@]}