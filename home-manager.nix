{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  services.kdeconnect = {
    enable = true;
    indicator = true;
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
    cursors.enable = false;
    kvantum.enable = true;
    gtk.icon.enable = true;
  };
  # /CATPUCCIN

  home = {
    stateVersion = "26.05";
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/nixos/scripts"
    ];
    username = "niedzwiedz";
    homeDirectory = "/home/niedzwiedz";
    packages = with pkgs; [
      # sysadmin stuff
      usbutils

      # terminal
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
      # aseprite
      firefox
      ffmpeg-full
      # audio
      # davinci-resolve
      anydesk
      spotify

      # utils
      evince
      papers
      losslesscut-bin
      keepassxc
      discord
      jq
      ungoogled-chromium
      slack
      rclone
      steam
      gedit
      protontricks
      (lutris.override {
        extraLibraries = pkgs: [
          pkgsi686Linux.libglvnd # 32-bit OpenGL compatibility libraries
          pkgsi686Linux.openalSoft # 32-bit OpenAL library
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
      brave
      acpi
      # ai
      opencode
      (pkgs.writeShellScriptBin "bigpicture" ''
        set -euo pipefail

        export STEAM_MULTIPLE_XWAYLANDS=1
        export STEAM_GAMESCOPE_HDR_SUPPORTED=1
        export STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT=1
        export STEAM_GAMESCOPE_COLOR_MANAGED=1
        export STEAM_USE_MANGOAPP=1
        export DXVK_HDR=1
        export PROTON_ENABLE_HDR=1
        export ENABLE_GAMESCOPE_WSI=1

        GAMESCOPE_LIMITER_FILE="$(${pkgs.coreutils}/bin/mktemp /tmp/gamescope-limiter.XXXXXXXX)"
        export GAMESCOPE_LIMITER_FILE

        exec /run/wrappers/bin/gamescope \
              --backend drm \
              -W 3840 -H 2160 -r 60 \
              -f -e --rt \
              --immediate-flips \
              --hdr-enabled \
              --hdr-sdr-content-nits 300 \
              --xwayland-count 2 \
              -- ${pkgs.util-linux}/bin/setpriv --inh-caps -all \
                 /run/current-system/sw/bin/steam -pipewire-dmabuf -gamepadui
      '')
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
          family = "Maple Mono NF";
        };
        fonts.extras = [
          {family = "Maple Mono";}
          {family = "Noto Color Emoji";}
          {family = "DejaVu Sans";}
        ];
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
    # ./home-manager/sway.nix
    ./home-manager/niri.nix
    ./home-manager/fish.nix
    ./home-manager/git.nix
    ./home-manager/zellij.nix
    ./home-manager/helix.nix
  ];
}
