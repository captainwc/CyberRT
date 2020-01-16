#!/usr/bin/env python3

# ****************************************************************************
# Copyright 2019 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ****************************************************************************
# -*- coding: utf-8 -*-
"""Module for example of listener."""

from cyber_py import cyber
from cyber.proto.unit_test_pb2 import ChatterBenchmark


def callback(data):
    print("-" * 80)
    print("get Request [ ", data, " ]")
    return ChatterBenchmark(content="svr: Hello client!", seq=data.seq + 2)


def test_service_class():
    """
    Reader message.
    """
    print("=" * 120)
    node = cyber.Node("service_node")
    r = node.create_service(
        "server_01", ChatterBenchmark, ChatterBenchmark, callback)
    node.spin()


if __name__ == '__main__':
    cyber.init()
    test_service_class()
    cyber.shutdown()
