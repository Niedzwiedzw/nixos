{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.11";
    };
    musnix = {url = "github:musnix/musnix";};
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";
    # nix-ld, used to run unpatched dynamnic binaries
    nix-ld = {
      url = "github:Mic92/nix-ld";
      # this line assume that you also have nixpkgs as an input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    chaotic,
    catppuccin,
    helix,
    nix-ld,
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
        nix-ld.nixosModules.nix-ld
        {programs.nix-ld.dev.enable = true;}
        # nixpkgs.nixosModules.sane_extra_backends.brscan4 # Reference to brscan4
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
