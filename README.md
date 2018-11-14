OCaml wasm in a separate docker container
===
Intended for development on OCaml wasm. 

To be able to edit the projects locally, a volume is used which maps 
to `workspace`. 

First time:
- `make install` 

Does the following:
- pulls a docker image from dockerhub
- copy the sources from the image to the workspace volume via rsync (will most likely take a while)

Editing:
- open the correct folder inside `workspace` in your editor, once done choose one of the following build commands

Build OCaml:
- `make build-ocaml`

Build OCaml for incremental development:
- `make ocaml`

Build LLD:
- `make build-lld`

Build WABT:
- `make build-wabt`

Build instructions for docker image:
- `make build-image`
- tag the image
- push to dockerhub
- update the tag in the make file
- push changes to github