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
    # nix index provides up-to-date binary cache
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    catppuccin,
    helix,
    nix-index-database,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    # nixos`
    nixosConfigurations.niedzwiedz = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        catppuccin.nixosModules.catppuccin
        stylix.nixosModules.stylix
        inputs.musnix.nixosModules.musnix

        ./configuration.nix

        nix-index-database.nixosModules.nix-index
      ];
      specialArgs = {inherit inputs;};
    };
    nixosConfigurations.vivobook = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        catppuccin.nixosModules.catppuccin
        stylix.nixosModules.stylix
        # inputs.musnix.nixosModules.musnix

        ./configuration--vivobook.nix

        nix-index-database.nixosModules.nix-index
      ];
      specialArgs = {inherit inputs;};
    };
    # home
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
