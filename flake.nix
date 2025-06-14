{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
    musnix = {url = "github:musnix/musnix";};
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    catppuccin,
    helix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.niedzwiedz = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        catppuccin.nixosModules.catppuccin
        stylix.nixosModules.stylix
        inputs.musnix.nixosModules.musnix

        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    homeConfigurations.niedzwiedz = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        helix-flake = helix;
      };
      modules = [
        ./home-manager.nix
        catppuccin.homeManagerModules.catppuccin
      ];
    };
  };
}
