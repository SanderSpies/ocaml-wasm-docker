clean:
	rm -rf workspace

clone:
	mkdir workspace
	mkdir workspace/llvmwasm
	mkdir workspace/llvmwasm/llvm-build
	git clone --recursive https://github.com/sanderspies/wabt workspace/wabt
	git clone https://github.com/SanderSpies/ocaml workspace/ocaml


build-image:
	cd docker && docker build --no-cache . -t ocaml-wasm-base

build-sm:
	docker build . -f docker/spidermonkey/Dockerfile -t ocaml-wasm-spidermonkey

run-sm:
	docker run --name ocaml-wasm-spidermonkey --rm -it  ocaml-wasm-spidermonkey /sm-root/sm/js/src/build_OPT.OBJ/js/src/js

run-sm-wabt:
	docker run --name ocaml-wasm-spidermonkey-container --rm -it -v `pwd`/workspace:/sm-root/workspace:z ocaml-wasm-spidermonkey bash

run-container-dev:
	docker run --name ocaml-wasm-bash --rm -dit -v `pwd`/workspace:/workspace:z ocaml-wasm-base bash

run-container:
	docker run --name ocaml-wasm-bash --rm -dit -v `pwd`/workspace:/workspace:z sanderspies/ocaml-wasm-test:0.8 bash

get-image:
	docker pull sanderspies/ocaml-wasm-test:0.8

copy-sources:
	mkdir -p workspace
	docker exec ocaml-wasm-bash mv /llvmwasm/llvm/tools/lld /workspace
	docker exec ocaml-wasm-bash mv /llvmwasm/llvm/lib/Object /workspace	
	docker exec ocaml-wasm-bash ln -sf /workspace/lld /llvmwasm/llvm/tools/lld
	docker exec ocaml-wasm-bash ln -sf /workspace/Object /llvmwasm/llvm/lib/Object
	docker exec ocaml-wasm-bash mv /wabt /workspace
	docker exec ocaml-wasm-bash mv /ocaml /workspace

build-ocaml:
	docker exec -w /workspace/ocaml ocaml-wasm-bash git checkout before_gc
	docker exec -w /workspace/ocaml ocaml-wasm-bash ./configure -no-pthread -no-debugger -no-curses -no-ocamldoc -no-graph -target-wasm32 -cc clang
	docker exec -w /workspace/ocaml ocaml-wasm-bash make coldstart
	docker exec -w /workspace/ocaml ocaml-wasm-bash make wasm32

build-wabt:
	docker exec -e LLVM_HOME=/llvmwasm/llvm-build -w /workspace/wabt ocaml-wasm-bash make

build-lld:
	docker exec -w /llvmwasm/llvm-build ocaml-wasm-bash make -j4

wasm32:
	docker exec -w /workspace/ocaml ocaml-wasm-bash make wasm32

install:
	make get-image
	make run-container
	make copy-sources
	make build-ocaml
