{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 53.013790;
    longitude = 18.598444;
    temperature = {
      night = 2000;
      day = 5000;
    };
    settings.general = {
      brightness-night = 0.6;
      brightness-day = 0.6;
    };
  };
  # CATPUCCIN
  catppuccin = {
    enable = true;
    flavor = "mocha";
    pointerCursor.enable = true;
  };
  # gtk.catppuccin.enable = true;
  gtk.catppuccin.icon.enable = true;
  qt.style.catppuccin.enable = true;
  # /CATPUCCIN

  home = {
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
    username = "niedzwiedz";
    homeDirectory = "/home/niedzwiedz";
    packages = with pkgs; [
      eza
      uv
      fd
      dust
      ripgrep
      bat
      wget
      curl
      libreoffice
      # rest
      # davinci-resolve
      gimp
      aseprite
      firefox
      ffmpeg-full
      # audio
      # davinci-resolve
      anydesk
      spotify
      reaper
      lsp-plugins
      chow-tape-model
      chow-phaser
      calf
      vital
      mda_lv2
      distrho-ports
      helm
      zam-plugins
      # utils
      evince
      losslesscut-bin
      keepassxc
      discord
      ungoogled-chromium
      slack
      rclone
      steam
      nexusmods-app
      gedit
      protontricks
      (lutris.override {
        extraLibraries = pkgs: [
          pkgsi686Linux.libglvnd # 32-bit OpenGL compatibility libraries
          pkgsi686Linux.openalSoft # 32-bit OpenAL library
          pkgs.wineWowPackages.stagingFull
          pkgs.winetricks
        ];
      })
      signal-desktop
      bacon
      git
      eza
      dust
      deluge
      mpv
      zellij
      # rust stuff
      clang
      cmake
      # cargo-make
      # stdenv.cc
      pkg-config
      # cargo
      # rustc
      #  thunderbird
      adw-gtk3
    ];
  };
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  programs = {
    rio = {
      enable = true;
      settings = {
        navigation = {
          use-split = false;
        };
        confirm-before-quit = false;
        editor = {
          program = "hx";
          args = [];
        };
        window = {
          opacity = 0.88;
          blur = true;
        };
        fonts = {
          size = 16;
          family = "Maple Mono";
        };
        # fonts.extras = [
        #   {family = "Noto Color Emoji";}
        #   {family = "DejaVu Sans";}
        # ];
      };
    };

    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    yt-dlp = {
      enable = true;
    };
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        enter_accept = false;
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
  imports = [
    ./home-manager/thunderbird.nix
    ./home-manager/sway.nix
    ./home-manager/fish.nix
    ./home-manager/git.nix
    ./home-manager/zellij.nix
    ./home-manager/helix.nix
  ];
}
