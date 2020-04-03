# Static Python

![Tests](https://github.com/FRidh/static-python/workflows/Tests/badge.svg?branch=master)

This repository contains a recipe for building a statically-linked Python
interpreter using Musl. The build is performed using the Nix package manager.
Dependencies are provided by Nixpkgs as well as the base recipe for Python.

## Building interpreters

To build an interpreter

    nix-build -A interpreters.python38

To build a tarball containing the interpreter

    nix-build -A tarballs.python38

## Binary cache

Tarballs and build-time closures are
[cached](https://app.cachix.org/cache/static-python) using
[Cachix](https://cachix.org/).

## Download builds

CI automatically uploads the tarballs containing interpreters. Go to the (latest)
CI run, and click on the Artifacts drop-down button.