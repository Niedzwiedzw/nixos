# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration--vivobook.nix
    # ./modules/audio-setup.nix
    # ./modules/brother-printer.nix
    # ./modules/jellyfin.nix
    # ./modules/hibernation.nix
    # only enable for magewell (mwcap) sessions
    # ./modules/magewell-legacy-compat.nix
    ./modules/wireguard--vivobook.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # RAID config
  # boot.swraid = {
  #   enable = true;
  #   mdadmConf = builtins.readFile ./mdadm.conf;
  # };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  services.flatpak.enable = true;
  services.atd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # amd gpu specific stuff

  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics.enable = true;

  # boot.initrd.luks.devices."luks-dc26d02c-eb73-4302-9367-2d313170c745".device = "/dev/disk/by-uuid/dc26d02c-eb73-4302-9367-2d313170c745";
  networking.hostName = "niedzwiedz-vivobook"; # Define your hostname.

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

  fonts = with pkgs; {
    packages = [
      noto-fonts
      noto-fonts-color-emoji
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
    enableDefaultPackages = true;
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
    sway.enable = true;
    fish.enable = true;
  };
  users.defaultUserShell = pkgs.fish;

  # capture card

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # global fonts
    noto-fonts
    noto-fonts-color-emoji
    dejavu_fonts

    # utils
    desktop-file-utils
    xdg-utils
    gnome-software
    comma

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

    # blender-hip
    # amdvlk
    amdgpu_top
    vulkan-tools
    mesa-demos
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
    # steamtinkerlaunch
    # steamtinkerlaunch
    # protonup-qt
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
    ]
    ++ (builtins.genList (x: x + 30000) 1001); # Opens 30000-31000 for unftp;
  networking.firewall.allowedUDPPorts = [
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
