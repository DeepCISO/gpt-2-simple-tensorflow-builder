# Build Custom TensorFlow Wheels with Docker

Builds niche TensorFlow wheels from source for your CPU architecture, out-of-the-box supporting TensorFlow versions preferred by [gpt-2-simple](https://github.com/minimaxir/gpt-2-simple). The following configurations are supported:

| TensorFlow Version | Python Version | CPU Architecture | On Docker? |
|:------------------:|:--------------:|------------------|------------|
| 1.15.4             |            3.6 |          aarch64 | [Yes!](https://hub.docker.com/layers/180451706/deepciso/tensorflow-docker-build-env/1.15.4-cp36-linux-aarch64/images/sha256-152393f037a4e1253c95b38c7098afd3d68e08e84bb964a63738ee8c1f2ccdd9) |
| 1.15.4             |            3.6 |              x86 | [Yes!](https://hub.docker.com/layers/131384108/deepciso/tensorflow-docker-build-env/1.15.4-cp36-linux-x86/images/sha256-c628a0f982bc626d4ecd7162c21e4e200df135f856ae7405e70ee03c2d9be35b) |

## Background

Existing [alternative build sources](https://github.com/lakshayg/tensorflow-build) do not provide their build environment, so building TensorFlow for our own CPU architecture forced us to start from scratch. Which is frustrating. So maybe you won't have to.

If you need something specific that isn't one of the specific TensorFlow wheels we needed, please enjoy adapting the Dockerfile (comments available within) and consider publishing your own version or contributing upstream. We will release new Docker images as needed for our own use, and will consider issues requesting specific configurations, but don't count on it.

## FAQ

* **Can you just give me the output so I don't have to build it myself?** There are [other projects](https://github.com/lakshayg/tensorflow-build) that do that. This is for people who want to build their own (for security, customizability, or specific features - whatever) and adapt from a fixed starting point, hopefully shaving down on the "build image, build TF, debug, restart" doldrums.
* **Does this support GPUs?** No, we use CPUs due to dataset constraints and, yknow, not having a 32GB GPU on hand. We'll accept PRs for GPU builds though, or link to your own project `tensorflow-gpu-docker-build-env`.

## Usage

If you'd like to build with the defaults (anything your CPU can take advantage of) you can run the Docker image directly and receive a TensorFlow binary tailored to your CPU in between 2 and 12 hours. For example, if you have an x86 (Intel/AMD-based) system, all you need to do is run:

```
docker run -v $PWD:/mnt deepciso/tensorflow-docker-build-env:1.15.4-cp36-linux-x86
```

If you have an aarch64 (Ampere/Graviton/etc.-based) system, run this instead:

```
docker run -v $PWD:/mnt deepciso/tensorflow-docker-build-env:1.15.4-cp36-linux-aarch64
```

## Advanced

If you want to change anything, for example building a TF 1.15.4 binary for an x86 CPU which is *not* the CPU you are running the Docker image on, you should enter an interactive shell on the Docker image and follow approximately these guidelines (changing configuration options for your specific usecase).

```
$ docker run -it -w /build/tensorflow -v $PWD:/mnt deepciso/tensorflow-docker-build-env:1.15.4-cp36-linux-x86
... puts you into a shell where you can run the following ...
# configure the build to your liking; note: no GPU support is possible without Dockerfile modifications
python3 configure.py
# use bazel to build tensorflow, adding any additional configuration options as desired
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
# build the wheel file and output to the mounted directory
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt
# optionally change UID/GID if necessary for you to access the file afterwards
```
