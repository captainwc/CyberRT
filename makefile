.PHONY: setup refresh-commands cyber test-all build-all clean clean-all

setup:
	@echo "You should execute \"source setup.bash\" by yourself"

refresh-commands:
	bazel run //:refresh_compile_commands

cyber:
	bazel build //cyber/...

test-all:
	bazel test //...

build-all:
	bazel build //...

clean:
	bazel clean

clean-all:
	bazel clean --expunge