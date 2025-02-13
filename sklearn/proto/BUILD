load("@rules_cc//cc:defs.bzl", "cc_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")
load("//tools/bazel:python_rules.bzl", "py_proto_library")

package(default_visibility = ["//visibility:public"])

proto_library(
    name = "person_proto",
    srcs = ["person.proto"],
)

cc_proto_library(
    name = "person_proto_cc",
    deps = [":person_proto"],
)

py_proto_library(
    name = "person_proto_py",
    deps = [":person_proto"],
)
