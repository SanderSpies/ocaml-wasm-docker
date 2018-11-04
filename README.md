First time:
- make full

Build OCaml:
- make build-ocaml

Build LLVM:
- make build-llvm



`make full` clones the used repositories in the `workspace` folder and are used by docker. You can change the sources here and run `make build-ocaml` to build OCaml wasm in docker.