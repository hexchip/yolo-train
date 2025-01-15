@echo off

set "datasetUrl=daydayup/cld-test3/7"
set "datasetFormat=yolov11"

:loop
if "%~1"=="" goto :run
if "%~1"=="--datasetUrl" set "datasetUrl=%~2" & shift & shift & goto :loop
if "%~1"=="--datasetFormat" set "datasetFormat=%~2" & shift & shift & goto :loop
echo Unknown parameter passed: %~1
exit /b 1

:run
if not exist "datasets\" (
    mkdir datasets
)

docker run -it --rm ^
  -v "%USERPROFILE%\.config\roboflow:/root/.config/roboflow" ^
  -v "%cd%\datasets:/datasets" ^
  hexchip/roboflow-downloader ^
  --datasetUrl "%datasetUrl%" ^
  --datasetFormat "%datasetFormat%"