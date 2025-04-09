#!/usr/bin/env bash

set -e

# use this location just beacuse i ofen build this cyber project in docker.
PROJECT_DIR=/workspace/fast-rtps

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

if [[ -d "${PROJECT_DIR}" ]]; then
    rm -rf ${PROJECT_DIR}
fi

git clone --single-branch --branch v1.5.0 --depth 1 \
    https://github.com/eProsima/Fast-RTPS.git ${PROJECT_DIR}
pushd ${PROJECT_DIR}
git submodule update --init
    patch -p1 < ${CURRENT_DIR}/FastRTPS_1.5.0.patch
mkdir -p build && cd build
cmake -DEPROSIMA_BUILD=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCOMPILE_EXAMPLES=ON \
    -DCMAKE_INSTALL_PREFIX=build/installed \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G"Ninja" \
    ..
ninja -j$(nproc)
popd
