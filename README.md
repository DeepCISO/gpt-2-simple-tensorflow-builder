# gpt-2-simple-tensorflow-builder

Builds niche TensorFlow binary from source for your CPU architecture.

## Background

gpt-2-simple makes it easy to get started with GPT-2. While it's faster to train on GPUs, we frequently ran into memory constraints on larger models and resorted to CPU training, which was easier to get a shitton of RAM for.

In order to maximize performance, we wanted to use a TensorFlow build which could use our CPU to its fullest extent, and existing [alternative build sources](https://github.com/lakshayg/tensorflow-build) do not provide their build environment. Due to gpt-2-simple's constraints (needs TF 1.14 or 1.15) and our laziness (what OS has a Python default version which is compatible with TF 1.14 or 1.15), we now provide this Dockerfile and corresponding image on Dockerhub which will build TensorFlow 1.15.4 from source for Python 3.6 on Linux with flags for your CPU architecture.

This is released under permissive license so you don't have to spend two days intermittently debugging builds and hunting down error messages if your usecase matches ours. If you need something specific that isn't a build of `tensorflow-1.15.4-cp36-cp36m-linux_x86_64.whl`, please enjoy adapting the Dockerfile (comments available within) and consider pusblishing your own version or contributing upstream.

## FAQ

* **Can output from this only be used for gpt-2-simple?** No, it's a TensorFlow pip package and can be used for anything TensorFlow would normally be used for. We just made it for our use of gpt-2-simple, since it's a slightly niche build and wasn't satisfied by other projects which distribute uncommon TensorFlow binaries.

## Usage

```
docker run -v $PWD:/mnt deepciso/gpt-2-simple-tensorflow-builder:1.15.4-cp36-linux-x86
```

```
docker run -it -w /build/tensorflow -v $PWD:/mnt deepciso/gpt-2-simple-tensorflow-builder:1.15.4-cp36-linux-x86
# configure the build to your liking; note: no GPU support is possible without Dockerfile modifications
python3 configure.py
# use bazel to build tensorflow, adding any additional configuration options as desired
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
# build the wheel file and output to the mounted directory
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt
# optionally change UID/GID if necessary for you to access the file afterwards
```