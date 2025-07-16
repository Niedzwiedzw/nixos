# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/audio-setup.nix
    ./modules/brother-printer.nix
    # only enable for magewell (mwcap) sessions
    # ./modules/magewell-legacy-compat.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # RAID config
  boot.swraid = {
    enable = true;
    mdadmConf = builtins.readFile ./mdadm.conf;
  };

  fileSystems."/mnt/md0" = {
    device = "/dev/md0"; # Adjust to the correct RAID device
    fsType = "ext4"; # Adjust to the correct filesystem type (e.g., ext4, xfs, etc.)
  };

  virtualisation.docker = {
    enable = true;
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # virtualbox
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableExtensionPack = true;
    guest.enable = true;
    guest.dragAndDrop = true;
  };
  users.extraGroups.vboxusers.members = ["niedzwiedz"];
  services.flatpak.enable = true;
  # home media server
  services.minidlna = {
    enable = true;
    settings = {
      friendly_name = "MEDIA MAIN";
      media_dir = ["V,/home/niedzwiedz/Downloads/torrent"];
      log_level = "error";
    };
  };
  users.users.minidlna = {
    extraGroups = ["users"];
  };
  services.atd.enable = true;
  # BACKUPS
  services.borgmatic = {
    enable = true;
    settings = {
      repositories = [
        {
          label = "local";
          path = "/mnt/md0/manual-backup/001-borgmatic";
        }
      ];
      source_directories = [
        "/home/niedzwiedz/firma-niedzwiedz"
      ];
      keep_daily = 7;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # amd gpu specific stuff

  boot.initrd.kernelModules = [
    "amdgpu"
    # for alsa visibility
    "snd-aloop"
  ];
  services.xserver.videoDrivers = ["amdgpu"];
  # chaotic.mesa-git.enable = true;
  hardware.graphics.enable = true;
  # environment.variables.AMD_VULKAN_ICD = "RADV";
  # end of amd gpu specific stuff

  # boot.initrd.luks.devices."luks-dc26d02c-eb73-4302-9367-2d313170c745".device = "/dev/disk/by-uuid/dc26d02c-eb73-4302-9367-2d313170c745";
  networking.hostName = "niedzwiedz-main"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.niedzwiedz = {
    isNormalUser = true;
    description = "niedzwiedz";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "docker"];
    packages = with pkgs; [
      home-manager
    ];
  };

  # STYLIX
  stylix = {
    enable = true;
    image = ./my-wallpaper-malysz-tajner-chester-linkin-park.png;
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 10;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
  fonts = with pkgs; {
    packages = [
      noto-fonts
      noto-fonts-emoji
      dejavu_fonts
      # noto-fonts-cjk-sans
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.iosevka
      # Maple Mono (Ligature TTF unhinted)
      maple-mono.truetype
      # Maple Mono NF (Ligature unhinted)
      maple-mono.NF-unhinted
      # Maple Mono NF CN (Ligature unhinted)
      maple-mono.NF-CN-unhinted
    ];
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Noto Sans"];
        monospace = ["DejaVu Sans Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  services.gvfs.enable = true;
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };

    kdeconnect = {
      enable = true;
    };
    steam.enable = true;
    sway.enable = true;
    fish.enable = true;
  };
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
  users.defaultUserShell = pkgs.fish;

  # capture card

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # global fonts
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts

    # utils
    comma
    teamviewer
    desktop-file-utils
    xdg-utils
    gnome-software

    # scanner, printer
    qpdf
    imagemagick
    sane-airscan
    # backups
    borgmatic
    # raid
    mdadm
    # devtools
    python3
    # chaotic stuff
    # firefox_nightly
    # end of chaotic stuff
    pavucontrol
    pulseaudio
    helvum
    gparted
    xorg.xhost.out
    bottom
    # inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    # -- amd gpu

    blender-hip
    # amdvlk
    amdgpu_top
    vulkan-tools
    glxinfo
    vulkan-headers
    vulkan-loader
    vulkan-extension-layer
    libGL
    libxkbcommon
    wayland-utils
    winePackages.wayland
    wine64Packages.wayland
    wineWow64Packages.wayland
    wineWowPackages.wayland
    waylandpp
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    shaderc
    directx-shader-compiler
    wayland.dev
    # gaming - STEAM
    mangohud
    gamemode
    # steamtinkerlaunch
    steamtinkerlaunch
    protonup-qt
    unixtools.xxd
    yad
    xorg.xwininfo
    unzip

    # WINE
    wine
    winetricks
    protontricks
    vulkan-tools
    # Extra dependencies
    # https://github.com/lutris/docs/
    gnutls
    openldap
    libgpg-error
    freetype
    sqlite
    libxml2
    xml2
    SDL2
    # -- end of amd gpu
    # crypto
    cryptsetup
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts =
    [
      8200 # minidlna
      21 # unftp
      2121 # unftp
      4455 # with-fire-and-sword
    ]
    ++ (builtins.genList (x: x + 30000) 1001); # Opens 30000-31000 for unftp;
  networking.firewall.allowedUDPPorts = [
    1900 # minidlna
    21 # unftp
    2121 # unftp
    4455 # with-fire-and-sword
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
