# `yolo.sh` 介绍

`yolo.sh` 本质上就是 [Ultralytics YOLO CLI](https://docs.ultralytics.com/usage/cli/)。它基于Docker容器统一了软件环境，并约定了一些使用逻辑。

## 容器化命令

每次运行`yolo.sh`都会启动一个容器，并将主机目录挂载进容器以便容器能够进行读写。  
容器启动后开始执行具体逻辑，执行完后容器销毁。

不理解容器的同学将其理解为虚拟机就行。  
区别在于，虚拟机启动要几十秒到几分钟，而大部分容器只需要几毫秒。

得利于容器的轻量性，这个过程就好像在主机上执行一个Shell命令那么快捷。

## `Docker run`很冗长

运行一个Docker容器，你可能需要写很长很长的命令。。。比如:

```bash
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
-v ./tmp:/home/cld \
--user 1000:1000 \
--gpu all \
--ipc=host \
-v ./datasets:/ultralytics/ultralytics/datasets \
-v ./sources:/ultralytics/sources:ro \
-v ./runs:/ultralytics/runs \
-v ./models:/ultralytics/models:ro \
hexchip/ultralytics:8.3.40 \
yolo detect train model=yolo11m.pt data=mydataset-1/data.yaml imgsz=320 epochs=200
```
甚至你还需要了解Dockerfile怎么写，以便于自己定制容器镜像。
这么说起来，容器化命令好像也不是那么香了。。。

好在我们有`Shell Script`！`yolo.sh`隐藏了这些复杂性。

## WSL显示图像窗口

值得一提的是，为了方便大家统一环境，`yolo.sh`能在WSl中运行并在主机显示图像窗口。

这得感谢 https://github.com/microsoft/wslg ！

## 硬件加速

NVIDIA在很久之前就很积极地为Docker提供了支持，所以有了`--gpu`这个参数。  
可惜到现在`--gpu`这个参数目前也只支持NVIDIA GPU。

至于AMD GPU或者其他厂商的GPU，应该都可以通过`--device`来解决。  
比如参考这篇AMD的文档：https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/docker.html