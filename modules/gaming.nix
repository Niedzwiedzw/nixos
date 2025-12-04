{pkgs, ...}: {
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          pango
          libthai
          harfbuzz
        ];
    };
  };
  programs = {
    java.enable = true;
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    steamtinkerlaunch
    protonup-qt
    mangohud
    gamemode
    # WINE
    winetricks
    protontricks
    # support 64-bit only
    (wine.override {wineBuild = "wine64";})
    # wine-staging (version with experimental features)
    wineWowPackages.stagingFull
  ];
}
