# Just ubuntu22.04 with some basic and useful tools, like g++ git bazel tmux uv etc
## You can get from https://raw.githubusercontent.com/captainwc/.dotfiles/refs/heads/main/scripts/docker/dockerfile-dev-base
FROM dev-base:latest

WORKDIR /workspace

RUN apt update && \
    git clone https://github.com/captainwc/quick-cmake.git && \
    mv quick-cmake/include/skutils /usr/local/include/ && \
    rm -rf quick-cmake && \
    /root/.local/modernunix/uv python install 3.9.21 && \
    git clone https://github.com/captainwc/CyberRT.git && \
    cd /workspace/CyberRT && /root/.local/modernunix/uv venv --python 3.9.21 && \
    cd /workspace/CyberRT/tools/install && DEBIAN_FRONTEND=noninteractive bash install_prereqs.sh && \
    echo '\nif [ -f /workspace/CyberRT/setup.bash ]; then\n    . /workspace/CyberRT/setup.bash;\nfi' >> /root/.bash_env && \
    echo '\nsource /workspace/CyberRT/.venv/bin/activate' >> /root/.bash_env && \
    ln -s /usr/local/fast-rtps/lib/libfastrtps.so.1 /lib/x86_64-linux-gnu/libfastrtps.so.1 && \
    ln -s /usr/local/fast-rtps/lib/libfast /lib/x86_64-linux-gnu/libfastcdr.so.1 && \
    ln -s ~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/lib/libpython3.9.so.1.0 /lib/x86_64-linux-gnu/libpython3.9.so && \
    ln -s ~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/lib/libpython3.9.so.1.0 /lib/x86_64-linux-gnu/libpython3.9.so.1 && \
    apt clean && rm -rf /var/lib/apt/lists/*  /tmp/*

WORKDIR /workspace/CyberRT
CMD [ "/bin/bash" ]

## Build images:
# docker build -t cyber-dev .
## Start Container:
# docker run -it --rm cyber-dev-latest:latest
## Run a demo:
# bazel run //sklearn/demos:sk_demo_communicate_topic_talker_cc
## FAILED, and then:
# rg -l "https://zlib.net/zlib-1.2.11.tar.gz" ~/.cache/bazel | xargs sed -i 's|https://zlib.net/zlib-1.2.11.tar.gz|https://www.zlib.net/fossils/zlib-1.2.11.tar.gz|g'
## now you can successfully run `make cyber`

