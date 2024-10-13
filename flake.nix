{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    musnix = {url = "github:musnix/musnix";};
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    chaotic,
    catppuccin,
    helix,
    # firefox,
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
        chaotic.nixosModules.default
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
