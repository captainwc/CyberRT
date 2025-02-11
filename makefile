.PHONY: setup debug find-exe refresh-commands cyber test-all build-all clean clean-all

setup:
	@echo "You should execute \"source setup.bash\" by yourself"

debug:
	@exe=$$(fd . bazel-bin -uu | fzf); \
	if [ -n "$$exe" ]; then \
		cgdb "$$exe"; \
	else \
		echo "No executable selected."; \
	fi;

find-exe:
	@exe=$$(fd . bazel-bin -uu | fzf); \
	if [ -n "$$exe" ]; then \
		echo "$$exe"; \
	else \
		echo "No executable selected."; \
	fi;

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