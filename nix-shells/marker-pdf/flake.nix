{
  description = "A dev shell with marker-pdf installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          python3Packages.pip
        ];

        shellHook = ''
          # Create a temporary virtual environment
          export VENV_DIR=$(mktemp -d)
          python -m venv $VENV_DIR
          source $VENV_DIR/bin/activate

          # Install marker-pdf
          pip install marker-pdf

          # Clean up on exit
          trap 'rm -rf $VENV_DIR' EXIT
        '';
      };
    });
}
