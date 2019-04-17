clean:
	rm -rf workspace

clone:
	mkdir workspace
	mkdir workspace/llvmwasm
	mkdir workspace/llvmwasm/llvm-build
	git clone --recursive https://github.com/sanderspies/wabt workspace/wabt
	git clone https://github.com/SanderSpies/ocaml workspace/ocaml

build-image-manual-gc:
	cd docker/manual-gc && docker build --no-cache . -t ocaml-wasm-manual-gc

build-image-fast-manual-gc:
	cd docker/manual-gc && docker build . -t ocaml-wasm-manual-gc

build-image-wasm-gc:
	cd docker/wasm-gc && docker build --no-cache . -t ocaml-wasm-base-gc

build-image-fast-wasm-gc:
	cd docker/wasm-gc && docker build . -t ocaml-wasm-base-gc

build-sm:
	cd docker/spidermonkey && docker build . -t ocaml-wasm-spidermonkey

run-sm:
	docker run --name ocaml-wasm-spidermonkey --rm -it  ocaml-wasm-spidermonkey /sm-root/sm/js/src/build_OPT.OBJ/js/src/js

run-container-dev-wasm-gc:
	docker run --name ocaml-wasm-bash-gc --rm -dit -v `pwd`/workspace-wasmgc:/workspace:z ocaml-wasm-base-gc bash	

run-container-dev-manual-gc:
	docker run --name ocaml-wasm-manual-gc --rm -dit -v `pwd`/workspace-manualgc:/workspace:z ocaml-wasm-manual-gc bash	

run-container-wasm-gc:
	docker run --name ocaml-wasm-bash-gc --rm -dit -v `pwd`/workspace-wasmgc:/workspace:z sanderspies/ocaml-wasm-test:0.12 bash

run-container-manual-gc:
	docker run --name ocaml-wasm-manual-gc --rm -dit -v `pwd`/workspace-manualgc:/workspace:z sanderspies/ocaml-wasm-test:0.12 bash

get-image:
	docker pull sanderspies/ocaml-wasm-test:0.12

copy-sources-manual-gc:
	mkdir -p workspace-manualgc
	docker exec ocaml-wasm-manual-gc mv /wabt /workspace
	docker exec ocaml-wasm-manual-gc mv /ocaml /workspace

copy-sources-wasm-gc:
	mkdir -p workspace-wasmgc
	docker exec ocaml-wasm-bash-gc mv /llvmwasm/llvm/tools/lld /workspace
	docker exec ocaml-wasm-bash-gc mv /llvmwasm/llvm/lib/Object /workspace	
	docker exec ocaml-wasm-bash-gc mv /llvmwasm/llvm/include /workspace	
	docker exec ocaml-wasm-bash-gc ln -sf /workspace/lld /llvmwasm/llvm/tools/lld
	docker exec ocaml-wasm-bash-gc ln -sf /workspace/Object /llvmwasm/llvm/lib/Object
	docker exec ocaml-wasm-bash-gc ln -sf /workspace/include /llvmwasm/llvm/lib/include
	docker exec ocaml-wasm-bash-gc mv /wabt /workspace
	docker exec ocaml-wasm-bash-gc mv /ocaml /workspace

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
