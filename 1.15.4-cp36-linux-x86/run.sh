#!/bin/bash
set -e

echo "[TDBE] Configuring build for tensorflow 1.15.4 on py3.6 with defaults for your CPU architecture ..."
cd /build/tensorflow
python3 configure.py

echo "[TDBE] Building tensorflow with bazel ..."
echo "[TDBE] Please put a Gatorade on your nightstand, chug [safe_quantity] beers, and check in the morning"
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package

echo "[TDBE] Building pip package for tensorflow ..."
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt

echo "[TDBE] Exiting normally - please install tensorflow from the wheel file in the directory you specified"
