#! /usr/bin/env bash

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 考虑到和zsh的兼容性，这里不用这几个函数了，直接用export设置
# source ${TOP_DIR}/tools/common.bashrc

export CYBER_PATH=${TOP_DIR}

BAZEL_BIN_DIR="${TOP_DIR}/bazel-bin"

export PATH=${BAZEL_BIN_DIR}/cyber_py3/tools:$PATH
export PATH=${BAZEL_BIN_DIR}/cyber/mainboard:$PATH
export PATH=${BAZEL_BIN_DIR}/cyber/tools/cyber_recorder:$PATH
export PATH=${BAZEL_BIN_DIR}/cyber/tools/cyber_monitor:$PATH

export PYTHON_BIN_PATH=~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/bin/python3.9
export PYTHON_LIB_PATH=~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/lib

export LIBRARY_PATH=/usr/local/fast-rtps/lib:${PYTHON_LIB_PATH}:${LIBRARY_PATH}
export LD_LIBRARY_PATH=${LIBRARY_PATH}:${LD_LIBRARY_PATH}

export PYTHONPATH=${BAZEL_BIN_DIR}:$PYTHONPATH
export PYTHONPATH=${BAZEL_BIN_DIR}/cyber_py3/internal:$PYTHONPATH

export CYBER_DOMAIN_ID=80
export CYBER_IP=127.0.0.1

export GLOG_log_dir="${TOP_DIR}/data/log"
export GLOG_alsologtostderr=1
export GLOG_colorlogtostderr=1
export GLOG_minloglevel=0

# for DEBUG log
#export GLOG_v=4

export sysmo_start=0

source ${TOP_DIR}/tools/cyber_completions.bash

if [ ! -d "data/log" ]; then
    mkdir -p data/log
fi

unset BAZEL_BIN_DIR TOP_DIR
