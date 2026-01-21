{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    musnix = {url = "github:musnix/musnix";};
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        # inputs.musnix.nixosModules.musnix

        ./configuration--vivobook.nix

        nix-index-database.nixosModules.nix-index
      ];
      specialArgs = {inherit inputs;};
    };
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        catppuccin.nixosModules.catppuccin
        # inputs.musnix.nixosModules.musnix

        ./configuration--thinkpad.nix

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
        catppuccin.homeModules.catppuccin
        # NIX INDEX
        nix-index-database.homeModules.nix-index
        # optional to also wrap and install comma
        {programs.nix-index-database.comma.enable = true;}
      ];
    };
    homeConfigurations.vivobook = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        helix-flake = helix;
      };
      modules = [
        ./home-manager.nix
        catppuccin.homeManagerModules.catppuccin
        # NIX INDEX
        nix-index-database.homeModules.nix-index
        # optional to also wrap and install comma
        {programs.nix-index-database.comma.enable = true;}
      ];
    };
    homeConfigurations.thinkpad = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        helix-flake = helix;
      };
      modules = [
        ./home-manager.nix
        catppuccin.homeManagerModules.catppuccin
        # NIX INDEX
        nix-index-database.homeModules.nix-index
        # optional to also wrap and install comma
        {programs.nix-index-database.comma.enable = true;}
      ];
    };
  };
}
