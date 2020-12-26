# tensorflow-docker-build-env

Builds niche TensorFlow binaries from source for your CPU architecture.

## Background

Existing [alternative build sources](https://github.com/lakshayg/tensorflow-build) do not provide their build environment. Simple as that. This is released under permissive license so you don't have to spend two days intermittently debugging builds and hunting down error messages. If you need something specific that isn't a build of `tensorflow-1.15.4-cp36-cp36m-linux_x86_64.whl`, please enjoy adapting the Dockerfile (comments available within) and consider pusblishing your own version or contributing upstream.

## FAQ

* **Can you just give me the output so I don't have to build it myself?** There are [other projects](https://github.com/lakshayg/tensorflow-build) that do that. This is for people who want to build their own (for security, customizability, or specific features - whatever) and adapt from a fixed starting point, hopefully shaving down on the "build image, build TF, debug, restart" doldrums.
* **Does this support GPUs?** No, we use CPUs due to dataset constraints and, yknow, not having a 32GB GPU on hand. We'll accept PRs for GPU builds though.

## Usage

If you'd like to build with the defaults (anything your CPU can take advantage of) you can run the Docker image directly (either by building or downloading off Docker Hub), and receive a TensorFlow binary tailored to your CPU in between 2 and 12 hours:

```
docker run -v $PWD:/mnt deepciso/gpt-2-simple-tensorflow-builder:1.15.4-cp36-linux-x86
```

If you want to change anything, for example building a TF 1.15.4 binary for a CPU which is *not* the CPU you are running the Docker image on, you should enter an interactive shell on the Docker image and follow approximately these guidelines (changing configuration options for your specific usecase).

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
