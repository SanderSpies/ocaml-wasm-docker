clean:
	rm -rf workspace/*

clone:
	mkdir workspace
	mkdir workspace/llvmwasm
	mkdir workspace/llvmwasm/llvm-build
	git clone https://github.com/sanderspies/llvm workspace/llvmwasm/llvm
	cd ./workspace/llvmwasm/llvm/tools && git clone https://github.com/sanderspies/lld lld
	git clone --recursive https://github.com/sanderspies/wabt workspace/wabt
	git clone https://github.com/SanderSpies/ocaml workspace/ocaml


build-image:
	cd docker && docker build . -t ocaml-wasm-base

run-container:
	docker run --name ocaml-wasm-bash --rm -dit -v /Users/Sander/Projects/ocaml-wasm-docker/workspace:/workspace ocaml-wasm-base bash	

build-llvm:	
	docker exec -w /workspace/llvmwasm/llvm-build ocaml-wasm-bash cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly /workspace/llvmwasm/llvm 
	docker exec -w /workspace/llvmwasm/llvm-build ocaml-wasm-bash make -j 6

build-ocaml:
	docker exec -w /workspace/ocaml ocaml-wasm-bash git checkout before_gc
	docker exec -e LLVM_HOME=/workspace/llvmwasm/llvm-build -w /workspace/ocaml ocaml-wasm-bash ./configure -no-pthread -no-debugger -no-curses -no-ocamldoc -no-graph -target-wasm32
	docker exec -e LLVM_HOME=/workspace/llvmwasm/llvm-build -w /workspace/ocaml ocaml-wasm-bash make coldstart
	docker exec -e LLVM_HOME=/workspace/llvmwasm/llvm-build -w /workspace/ocaml ocaml-wasm-bash make wasm32

build-wabt:
	docker exec -e LLVM_HOME=/workspace/llvmwasm/llvm-build -w /workspace/wabt ocaml-wasm-bash make

wasm32:
	docker exec -w /workspace/ocaml ocaml-wasm-bash make wasm32

full:
	make clean
	make clone
	make build-image
	make run-container
	make build-llvm
	make build-wabt
	make build-ocaml