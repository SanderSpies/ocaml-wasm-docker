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

## Using spidermonkey to try out experimental wasm

- `make build-sm` to build spidermonkey
- `make run-sm-wabt` to run and connect to the container interactively. This will load the bash shell. To log into the spidermonkey shell directly, use `make run-sm`
- Once attached to the container (ocaml-wasm-spidermonkey-container) `sm-wabt-wrapper` is available to you in the path. Use `sm-wabt-wrapper output.wasm input.wat` to create .wasm files from .wat inside the `workspace` directory

## Issues

If you are using docker-for-mac or docker-for-windows, you'll probably need to increase limit resources available to Docker. 
You can find these settings at Docker > Preferences > Advanced.

Following setup is working fine. If you need less resources, a quick binary search would help.

- CPUs: 3
- Memory: 4.0 GiB
- Swap: 3.5 giB

