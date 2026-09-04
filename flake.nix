{ ... }:

{
  description = "Modern Environment for ML projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Define the target architecture (adjust as needed)
      system = "x86_64-linux"; 
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # devShells.<system>.default maps directly to the bare `nix develop` command
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python314
          pkgs.python314.pkgs.numpy
          pkgs.python314.pkgs.matplotlib
          pkgs.python314.pkgs.tkinter
        ];

        nativeBuildInputs = with pkgs; [
          gcc
          gnumake
          glibc
          glibc.dev
          llvmPackages.openmp
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
          export C_INCLUDE_PATH="$C_INCLUDE_PATH:${pkgs.glibc.dev}/include:${pkgs.glibc}/include"
          export CPLUS_INCLUDE_PATH="${pkgs.glibc.dev}/include"
          export MPLBACKEND="TkAgg"
          cat <<EOF > .clangd
          CompileFlags:
            Add:
          $(echo $C_INCLUDE_PATH | tr ':' '\n' | sed 's/^/    - -I/')
          EOF
          echo "=== NixOS Library Bridge Active ==="
          echo "*** Welcome to the thesis shell!!!! ****"
          echo "### Let's get to work! ###"
        '';
      };
    };
}
