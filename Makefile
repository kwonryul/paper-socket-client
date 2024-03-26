current_dir := $(shell pwd)
project_dir := $(shell cat ~/.paper-socket-client/project-directory)

.PHONY: init
init:
	echo "Setting project-directory..."
	mkdir -p ~/.paper-socket-client
	echo -n "${current_dir}/" > ~/.paper-socket-client/project-directory
	sudo mkdir -p /root/.paper-socket-client
	sudo cp ~/.paper-socket-client/project-directory /root/.paper-socket-client/project-directory

.PHONY: update_cabal
update_cabal:
	echo "Updating cabal..."
	cat paper-socket-client.cabal.raw | sed "s#\$${project_dir}#${project_dir}#g" > paper-socket-client.cabal

.PHONY: cpp_make
cpp_make:
	cd c && make build

.PHONY: clean_build
clean_build:
	-rm -rf dist-newstyle

.PHONY: build
build: clean_build update_cabal cpp_make
	cabal build

.PHONY: run
run:
	echo "Running..."
	export LD_LIBRARY_PATH=${project_dir}c/build && cabal run	