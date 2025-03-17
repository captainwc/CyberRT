.PHONY: setup run debug find-exe refresh-commands cyber test-all build-all clean clean-all

first-demo:
	bazel run //sklearn/demos:sk_demo_communicate_topic_talker_cc

fix:
	@echo "Fixing the broken links in the WORKSPACE file"
	rg -l "https://zlib.net/zlib-1.2.11.tar.gz" ~/.cache/bazel | xargs sed -i 's|https://zlib.net/zlib-1.2.11.tar.gz|https://www.zlib.net/fossils/zlib-1.2.11.tar.gz|g'

	@echo "Fix git remote url from https to ssh"
	rg -l -uu "https://github.com.captainwc/CyberRT.git" /workspace/CyberRT/.git | xargs sed -i 's#https://github.com.captainwc/CyberRT.git#git@github.com:captainwc/CyberRT.git#g'

setup:
	@echo "You should execute \"source setup.bash\" by yourself"
	@echo "But if you use docker, then you can ignore this message"

run:
	@exe=$$(fd . bazel-bin -uu | fzf); \
	if [ -n "$$exe" ]; then \
		./$$exe; \
	else \
		echo "No executable selected."; \
	fi;

debug:
	@exe=$$(fd . bazel-bin -uu | fzf); \
	if [ -n "$$exe" ]; then \
		cgdb -q "$$exe"; \
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
