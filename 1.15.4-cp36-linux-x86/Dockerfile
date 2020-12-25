FROM ubuntu:18.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# copy simple build script
COPY run.sh /build/run.sh

# install main dependencies
# install correct version of bazel for tensorflow 1.15.4 (min 0.24.1, max 0.26.1)
# https://www.tensorflow.org/install/source
# https://github.com/tensorflow/tensorflow/blob/df8c55ce12b5cfc6f29b01889f7773911a75e6ef/configure.py
# https://docs.bazel.build/versions/master/install-ubuntu.html
RUN apt-get update -y && \
    apt-get install -y \
        curl \
        g++ \
        unzip \
        zip \
        openjdk-11-jdk \
        python3-dev \
        python3-pip \
        git && \
    curl -L https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-installer-linux-x86_64.sh -o bazel-0.26.1-installer-linux.sh && \
    bash bazel-0.26.1-installer-linux.sh && \
    rm bazel-0.26.1-installer-linux.sh && \
    rm -rf /var/lib/apt/lists/*

# install tensorflow-building python prerequisites
# https://www.tensorflow.org/install/source
# https://github.com/tensorflow/tensorflow/issues/41061
RUN pip3 install --no-cache-dir 'numpy<1.19.0' && \
    pip3 install --no-cache-dir keras_preprocessing==1.1.2 --no-deps && \
    pip3 install --no-cache-dir keras_applications==1.0.8 --no-deps && \
    pip3 install --no-cache-dir six wheel mock pandas

# acquire tensorflow and change to commit tagging release 1.15.4
RUN mkdir -p /build && \
    cd /build && \
    git clone https://github.com/tensorflow/tensorflow.git && \
    cd /build/tensorflow && \
    git checkout df8c55ce12b5cfc6f29b01889f7773911a75e6ef && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

ENTRYPOINT ["bash", "/build/run.sh"]