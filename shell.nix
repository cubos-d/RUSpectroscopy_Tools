{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "thesis-shell";

  buildInputs = [
    pkgs.python314
    pkgs.python314.pkgs.numpy
  ];

  shellHook = ''
    # Explicitly target a folder named .venv in the parent directory
    if [ ! -d "../.venv" ]; then
      uv venv ../.venv
    fi
    source ../.venv/bin/activate
    export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    export C_INCLUDE_PATH="${pkgs.python314}/include/python3.14:${pkgs.python314.pkgs.numpy}/lib/python3.14/site-packages/numpy/_core/include"
    export C_INCLUDE_PATH="$C_INCLUDE_PATH:${pkgs.llvmPackages.openmp}/include"
    echo "=== NixOS Library Bridge Active ==="
    echo "*** Welcome to the thesis shell!!!! ****"
    echo "### Let's get to work! ###"
  '';
}
