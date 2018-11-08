FROM ubuntu:18.10

# RUN apt-get update
# RUN apt-get install -y wget
# RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
# RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main"
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y clang
RUN apt-get install -y lld-7
RUN apt-get install -y cmake

ENV PATH $PATH:/usr/lib/llvm-7/bin
ENV LLVM_HOME /usr/lib/llvm-7
VOLUME /workspace

# WORKDIR /workspace/llvmwasm/llvm-build
# RUN cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly /workspace/llvmwasm/llvm 
# RUN make -j 6

# WORKDIR /workspace/wabt
# RUN make

# WORKDIR /workspace/ocaml
# ENV LLVM_HOME /workspace/llvmwasm/llvm-build
# RUN git checkout before_gc
# RUN ./configure -no-pthread -no-debugger -no-curses -no-ocamldoc -no-graph -target-wasm32
# RUN make coldstart	
# RUN ../wabt/bin/wasm2wat --help
# RUN make wasm32