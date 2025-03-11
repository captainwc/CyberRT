# How to build this project

## 1. 编译安装 fastrtps

```bash
cd tools/install && ./install_prereqs.sh
```

这会下载编译 `fastrtps v1.5.0` 并安装到 `/usr/local/fast-rtps`

环境变量的配置参见下文

## 2. 确保 python 版本

这项目有点老，对python版本有要求，高了低了都不行（受制于protobuf的编译，用到的CAPI， 3.10开始有的用到的老特性不支持了）
经过尝试，推荐`3.9.15`（既可以通过protobuf的编译，又可以通过生成compile_commands.josn的编译）

可以选择pyenv或者uv

### 2.1 安装uv

```bash
#（1）安装uv(完了之后会让你把 ~/.local/bin添加到环境变量)
curl -LsSf <https://astral.sh/uv/install.sh> | sh

# (2) 安装python3.9
uv python install 3.9 

# (3) 设置环境
uv venv --python 3.9
source .venv/bin/activate

# (4) 修改source.bash中的python位置为你的python路径
uv python list
```

### 2.2 安装pyenv

```bash
    #(1) 安装依赖
    sudo apt update && sudo apt install -y --no-install-recommends \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git

    #(2) 安装 pyenv
    curl https://pyenv.run | bash
    ## 然后会让你往bashrc中写入一些东西，照做

    #(3) 安装python3.8.12
    pyenv install 3.9.15
    ## 本项目指定了 .python-version 文件，因此进入文件夹后会自动切换
```

### 2.2 配置python3.9环境

直接参见下面关于环境变量的配置

## 3 所有需要的环境变量

已经写入 setup.bash， 直接source即可

```bash
#(1) bazel 需要指定python工具链
export PYTHON_BIN_PATH=~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/bin/python3.9
export PYTHON_LIB_PATH=~/.local/share/uv/python/cpython-3.9.21-linux-x86_64-gnu/lib
# OR
export PYTHON_BIN_PATH=$(pyenv prefix)/bin/python3.9
export PYTHON_LIB_PATH=$(pyenv prefix)/lib/python3.9

#(2) 指定编译、运行时的链接库查找位置，主要是 -lpython3.9 和 -lfastrtps
export LIBRARY_PATH="/usr/local/fast-rtps/lib:${PYTHON_LIB_PATH}":${LIBRARY_PATH}
export LD_LIBRARY_PATH=${LIBRARY_PATH}:${LD_LIBRARY_PATH}

#(注) 也可以将fast-rtps的库添加到默认位置，这样运行更方便（比如可以直接在vscode里面点击run运行，而不是报找不到库的错）
ln -s /usr/local/fast-rtps/lib/libfastrtps.so.1 /lib/x86_64-linux-gnu/libfastrtps.so.1
ln -s /usr/local/fast-rtps/lib/libfast /lib/x86_64-linux-gnu/libfastcdr.so.1

```

## 4 报错

1. 下载 `zlib-1.2.11.tar.gz` 的时候出错，因为那个链接失效了，**出现报错后**直接执行以下命令而后重新build即可

```bash
rg -l "https://zlib.net/zlib-1.2.11.tar.gz" ~/.cache/bazel | xargs sed -i 's|https://zlib.net/zlib-1.2.11.tar.gz|https://www.zlib.net/fossils/zlib-1.2.11.tar.gz|g'
```

2. 如果设置了python lib的path之后仍然报错：/usr/bin/ld.gold: error: cannot find -lpython3.8
那么直接去修改 `~/.cache/bazel/.../external/local_config_python/_python3/BUILD:5:linkopts`，直接在这里加上 "-L/home/shuaikai/.pyenv/versions/3.9.15/lib",

## 注：对原项目的修改

1. tools/install/install_prereqs.sh 中 fastrtps v1.5.0 分支丢失，通过 `git ls remote`找到对应的tag修改克隆连接
2. setup.bash 中统统改为用 export 设置环境变量
3. zlib链接失效，需要改成 <https://www.zlib.net/fossils/zlib-1.2.11.tar.gz>
4. 添加了 .bazelversion 和 .python-version 限制工具版本
5. 生成compile_command.json

## 5. debug

1. build --config=debug AND cgdb xxx
2. 参考这个launch.json，使用lldb调

```json

{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "lldb",
            "request": "launch",
            "name": "DebugBazelBin",
            "program": "bazel-bin/examples/cyber/talker",
            "args": [],
            "cwd": "${workspaceFolder}",
            "env": {
                "LD_LIBRARY_PATH": "/usr/local/fast-rtps/lib:/home/shuaikai/.pyenv/versions/3.9.15/lib"
            },
            "sourceMap": {
                "/proc/self/cwd": "${workspaceFolder}" // 必须要，否则找不到源文件位置
            }
        }
    ]
}

```

---

>[!info]
以下为原项目的 README

---

# Introduction

Apollo Cyber RT is an open source, high performance runtime framework designed
specifically for autonomous driving (AD) scenarios. Based on a centralized
computing model, it is greatly optimized for high concurrency, low latency, and
high throughput in autonomous driving.

During the last few years of development of AD technologies, we have learned a
lot from our previous experience with Apollo. The industry is evolving and so is
Apollo. Going forward, Apollo has already moved from development to production.
With volume deployment in real world, we see demands for the highest level of
robustness and performance. That’s why we spent years building and perfecting
Apollo Cyber RT, which addresses those requirements of AD solutions.

Key benefits of using Apollo Cyber RT:

- Accelerate development
  - Well defined task interface with data fusion
  - Array of development tools
  - Large set of sensor drivers
- Simplify deployment
  - Efficient and adaptive message communication
  - Configurable user level scheduler with resource awareness
  - Portable with fewer dependencies
- Empower your own autonomous vehicles
  - The default open source runtime framework
  - Building blocks specifically designed for AD scenarios
  - Plug and play your own AD system

# Build/Installation

## Dependencies

You can run the following command to install CyberRT pre-requisites:

```bash
bash tools/install/install_prereqs.sh
```

`sudo` privilege is needed, and by default Fast-DDS is installed under
`/usr/local/fast-rtps/`.

## Build

```bash
source setup.bash
bazel build //...
bazel test //...
```

## Release Build

Binary releases for CyberRT is still a Work-In-Progress. Contribution is highly
appreciated.

# Documents

- [Apollo Cyber RT Quick Start](https://github.com/ApolloAuto/apollo/tree/master/docs/cyber/CyberRT_Quick_Start.md):
  Everything you need to know about how to start developing your first
  application module on top of Apollo Cyber RT.

- [Apollo Cyber RT Developer Tools](https://github.com/ApolloAuto/apollo/tree/master/docs/cyber/CyberRT_Developer_Tools.md):
  Detailed guidance on how to use the developer tools from Apollo Cyber RT.

- [Apollo Cyber RT API for Developers](https://github.com/ApolloAuto/apollo/tree/master/docs/cyber/CyberRT_API_for_Developers.md):
  A comprehensive guide to explore all the APIs of Apollo Cyber RT, with many
  concrete examples in source code.

- [Apollo Cyber RT FAQs](https://github.com/ApolloAuto/apollo/tree/master/docs/cyber/CyberRT_FAQs.md):
  Answers to the most frequently asked questions about Apollo Cyber RT.

- [Apollo Cyber RT Terms](https://github.com/ApolloAuto/apollo/tree/master/docs/cyber/CyberRT_Terms.md):
  Commonly used terminologies in Cyber RT documentation and code.

- [Apollo Cyber RT Python Wrapper](python/README.md): Develop projects in
  Python.

More documents to come soon!
