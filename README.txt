# AI tool environment

enter shell with all AI tools:

cd aienv
nix develop .#nvidia --command $SHELL

execute some checks to confirm environment is ready:

./check_env

# llama-cpp

mkdir -p llama-cpp-dev && cd llama-cpp-dev && nix develop github:NixOS/nixpkgs/nixos-23.11#llama-cpp
genericBuild && cd ..
nix shell github:NixOS/nixpkgs/nixos-23.11#{clang-tools,helix} --command hx -- examples/main/main.cpp
