FROM ubuntu:19.04

RUN apt-get update
RUN apt-get install -y curl gnupg2
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y cmake
RUN apt-get install -y clang
RUN apt-get install -y llvm
RUN apt-get install -y lld
RUN apt-get install -y rsync
# RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
# RUN apt-get update
RUN apt-get install -y nodejs


WORKDIR /
RUN git clone --recursive https://github.com/webassembly/wabt
RUN git clone https://github.com/SanderSpies/ocaml

WORKDIR /wabt
RUN make

WORKDIR /ocaml
RUN git checkout manual_gc
ENV LLVM_HOME /usr/lib/llvm-8

WORKDIR /workspace/ocaml