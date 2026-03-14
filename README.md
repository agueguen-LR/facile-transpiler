# facile-transpiler

Transpiler for the "Facile" language, a small programming language that transpiles into [Common Intermediate Language](https://en.wikipedia.org/wiki/Common_Intermediate_Language).


Third year University project, instructions given for the project are available [here](./Project_Instructions.pdf).

## Usage

Compile the Transpiler:

```bash
mkdir build
cmake -B build
cd build
make
```

Example code to transpile is available in the [test](./test/) directory:

```bash
chmod +x ./facile #if the transpiler doesn't have executable privileges
./facile ../test/<script_name>.facile
```

This should create a CIL script named `<script_name>.il` in your current directory, which you can compile with [ilasm](https://en.wikipedia.org/wiki/ILAsm) and, if you're not on Windows, run with [mono](https://www.mono-project.com/).


If you have the necessary tools installed, you can run facile code directly with the provided [test script](./test/run_script.sh):

```bash
# You should still be in the build folder
chmod +x ../test/run_script.sh
../test/run_script ../test/<script_name>.facile
```

## Grammar

The grammar of the language is available in Extensible Backus-Naur Form (EBNF) in the  [`grammar.ebnf`](./grammar.ebnf) file.

## Nix

A Nix Flake development environment is available for this project:

```bash
nix develop
```

There is also a [.envrc](./.envrc) file for use with [nix-direnv](https://github.com/nix-community/nix-direnv)
