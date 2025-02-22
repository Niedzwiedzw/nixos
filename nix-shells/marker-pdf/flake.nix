{
  description = "Dev shell with marker-pdf installed via pip";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.python3
        pkgs.python3Packages.pip
      ];
      shellHook = ''
        # Only install marker-pdf if it's not already present
        if ! python3 -c "import marker_pdf" 2>/dev/null; then
          echo "Installing marker-pdf via pip..."
          pip install --user marker-pdf
        fi
      '';
    };
  };
}
