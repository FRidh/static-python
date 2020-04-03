# Static Python

This repository contains a recipe for building a statically-linked Python
interpreter using Musl. The build is performed using the Nix package manager.
Dependencies are provided by Nixpkgs as well as the base recipe for Python.

## Building interpreters

To build an interpreter

    nix-build -A interpreters.python38

To build a tarball containing the interpreter

    nix-build -A tarballs.python38
