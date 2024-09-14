{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };
    musnix = {url = "github:musnix/musnix";};
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    chaotic,
    # firefox,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.niedzwiedz = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        stylix.nixosModules.stylix
        inputs.musnix.nixosModules.musnix

        ./configuration.nix
        chaotic.nixosModules.default
      ];
      specialArgs = {inherit inputs;};
    };
    homeConfigurations.niedzwiedz = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home-manager.nix
      ];
    };
  };
}
