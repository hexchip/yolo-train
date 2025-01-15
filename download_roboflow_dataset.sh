#!/bin/bash

set -e

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Download Roboflow datasets"
    echo
    echo "Options:"
    echo "  --datasetUrl      Dataset URL in Roboflow (default: hexchip/honor-of-kings-u8coa/1)"
    echo "  --datasetFormat   Dataset format to download (default: yolov11)"
    echo "  --help            Show this help message"
    echo
    echo "Example:"
    echo "  $0 --datasetUrl myproject/mydataset/1 --datasetFormat yolov11"
}

datasetUrl="hexchip/honor-of-kings-u8coa/1"
datasetFormat="yolov11"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --datasetUrl) 
            [[ -z "$2" ]] && echo "Error: --datasetUrl requires a value" >&2 && usage && exit 1
            datasetUrl="$2"
            shift 
            ;;
        --datasetFormat) 
            [[ -z "$2" ]] && echo "Error: --datasetFormat requires a value" >&2 && usage && exit 1
            datasetFormat="$2"
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

if [ ! -d "./datasets" ]; then
    mkdir datasets
fi

if [ ! -d "~/.config/roboflow" ]; then
    mkdir -p ~/.config/roboflow
fi

docker run -it --rm --pull always \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro \
--user $(id -u):$(id -g) \
-v ~/.config/roboflow:/home/$(whoami)/.config/roboflow \
-v ./datasets:/datasets \
registry.cn-hangzhou.aliyuncs.com/hexchip/download-roboflow-dataset \
--datasetUrl "$datasetUrl" \
--datasetFormat "$datasetFormat"