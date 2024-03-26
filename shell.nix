{ pkgs, pkgs-unstable, cuda ? true }:

let
  llama-cpp-ovr = pkgs.llama-cpp.override { 
    cudaSupport = cuda; 
    # openblasSupport = false; 
  };
in
pkgs.mkShell rec {
  name = "ai";

  packages = with pkgs; [
    rustup
    pkg-config
    cmake
    clang-tools

    openssl

    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi

    libGL

    # gcc10Stdenv.glibc

    git
    lazygit

    #vim
    lunarvim
    helix
    lapce
    alacritty

    julia
    python311

    # pkgs-unstable.pixi

    # libgcc.lib

    gnumake

    llama-cpp-ovr
    (ollama.override { 
      acceleration = if cuda then "cuda" else null;
    })
    openai-whisper-cpp
    piper-tts

    ffmpeg
    alsa-utils

    makefile2graph
    graphviz

    # gephi
    # cytoscape
    graphia

    htop
    nvtop

    sunshine
    moonlight-qt
  ] 
  ++ gcc11Stdenv.defaultBuildInputs
  ++ gcc11Stdenv.defaultNativeBuildInputs
  ++ (if cuda then [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ] else []);

  buildInputs = [];

  # shellHook = ''
  #     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)}";
  # '';

  shellHook = ''
      export LD_LIBRARY_PATH="${pkgs.libgcc.lib}/lib:${pkgs.zlib}/lib:/run/opengl-driver/lib:$LD_LIBRARY_PATH";
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$PWD/.venv/bin:$PATH"
  '' + (if cuda then ''
      export CUDA_ROOT="${pkgs.cudaPackages.cudatoolkit}"
      export CUDNN_LIB="${pkgs.cudaPackages.cudnn}"
      '' else "");
}

