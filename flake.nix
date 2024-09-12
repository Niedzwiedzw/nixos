{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };
    musnix = {url = "github:musnix/musnix";};
    stylix.url = "github:danth/stylix";
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watershot = {
      url = "github:Kirottu/watershot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    firefox,
    watershot,
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
