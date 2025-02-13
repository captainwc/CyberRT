load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@rules_python//python:defs.bzl", "py_binary")
load("//tools/bazel:cpplint.bzl", "cpplint")

cc_binary(
    name = "sk_demo_proto_cc",
    srcs = ["sk_demo_proto_cc.cc"],
    deps = [
        "//cyber",
        "//sklearn/proto:person_proto_cc",
    ],
)

cc_binary(
    name = "sk_demo_communicate_topic_talker_cc",
    srcs = ["sk_demo_communicate_topic_talker_cc.cc"],
    deps = [
        "//cyber",
        "//sklearn/proto:person_proto_cc",
    ],
)

cc_binary(
    name = "sk_demo_communicate_topic_listener_cc",
    srcs = ["sk_demo_communicate_topic_listener_cc.cc"],
    deps = [
        "//cyber",
        "//sklearn/proto:person_proto_cc",
    ],
)

py_binary(
    name = "sk_demo_proto_py",
    srcs = ["sk_demo_proto_py.py"],
    deps = [
        "//cyber_py3:cyber",
        "//sklearn/proto:person_proto_py",
    ],
)

cpplint()
