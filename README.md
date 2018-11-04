OCaml wasm in a separate docker container
===
Intended for development on OCaml wasm. 

Uses: 
- llvm
- wabt
- OCaml wasm

To be able to edit the projects locally, a volume is used which maps 
to `workspace`. 

First time:
- `make full` 

Warning: might take some time.

Editing:
- open the correct folder inside `workspace` in your editor, once done choose one of the following build commands

Build OCaml:
- `make build-ocaml`

Build OCaml:
- `make wasm32`

For incremental development.

Build LLVM:
- `make build-llvm`

Build wabt:
- `make build-wabt`

