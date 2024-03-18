{
  description = "AI environment with tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfreePredicate = pkg: true;
    };
  in {
    devShells = {
      cpu = import ./shell.nix { 
        inherit pkgs pkgs-unstable; 
        cuda = false;
      };
      nvidia = import ./shell.nix { 
        inherit pkgs pkgs-unstable; 
        cuda = true;
      };
    };
    packages = {
      inherit (pkgs) llama-cpp;
    };
  });
}
