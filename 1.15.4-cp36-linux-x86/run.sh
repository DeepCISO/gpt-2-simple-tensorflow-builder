#!/bin/bash
set -e

echo "[GPT2S/TFB] Configuring build for tensorflow 1.15.4 on py3.6 with defaults for your CPU architecture ..."
sleep 5
cd /build/tensorflow
python3 configure.py

echo "[GPT2S/TFB] Building tensorflow with bazel ..."
echo "[GPT2S/TFB] Please put a Gatorade on your nightstand, chug [safe_quantity] beers, and check in the morning"
sleep 5
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package

echo "[GPT2S/TFB] Building pip package for tensorflow ..."
sleep 5
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt

echo "[GPT2S/TFB] Exiting normally - please install tensorflow from the wheel file in the directory you specified"