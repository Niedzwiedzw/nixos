# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  # inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    guest.enable = true;
    guest.dragAndDrop = true;
  };
  users.extraGroups.vboxusers.members = ["niedzwiedz"];
  services.flatpak.enable = true;
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

  # scanner, printer etc
  services.udev.packages = [pkgs.sane-airscan];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.userServices = true;
  hardware.sane = {
    enable = true;
    disabledDefaultBackends = ["escl" "v4l"];
    extraBackends = [pkgs.sane-airscan];
    brscan4 = {
      enable = true;
      netDevices = {
        home = {
          model = "MFC-B7715DW";
          ip = "192.168.1.11";
        };
      };
    };
    brscan5 = {
      enable = true;
      netDevices = {
        home = {
          model = "MFC-B7715DW";
          ip = "192.168.1.11";
        };
      };
    };
  };

  # amd gpu specific stuff
  boot.initrd.kernelModules = ["amdgpu"];
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

  # Enable CUPS to print documents.
  services.printing.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "524288";
    }
  ];
  security.polkit.enable = true;
  services.pipewire = {
    # low latency alsa
    # wireplumber.extraLuaConfig.main."99-alsa-lowlatency" = ''
    #   alsa_monitor.rules = {
    #     {
    #       matches = {{{ "node.name", "matches", "alsa_output.*" }}};
    #       apply_properties = {
    #         ["audio.format"] = "S32LE",
    #         ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
    #         ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
    #         -- ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
    #       },
    #     },
    #   }
    # '';

    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-lowlatency.lua" ''
        alsa_monitor.rules = {
          {
            matches = {{{ "node.name", "matches", "alsa_output.*" }}};
            apply_properties = {
              ["audio.format"] = "S32LE",
              ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
              ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
              ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
            },
          },
        }
      '')
    ];

    extraConfig.pipewire = {
      "91-null-sinks" = {
        "context.objects" = [
          {
            # A default dummy driver. This handles nodes marked with the "node.always-driver"
            # properyty when no other driver is currently active. JACK clients need this.
            factory = "spa-node-factory";
            args = {
              "factory.name" = "support.node.driver";
              "node.name" = "Dummy-Driver";
              "priority.driver" = 8000;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Microphone-Proxy";
              "node.description" = "Microphone";
              "media.class" = "Audio/Source/Virtual";
              "audio.position" = "MONO";
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Main-Output-Proxy";
              "node.description" = "Main Output";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
      };
      "92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  musnix.enable = true;
  users.users.niedzwiedz = {
    isNormalUser = true;
    description = "niedzwiedz";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "scanner" "lp" "docker"];
    packages = with pkgs; [
      home-manager
    ];
  };

  # STYLIX
  stylix = {
    enable = true;
    image = ./my-wallpaper-malysz-tajner-chester-linkin-park.png;
    polarity = "dark";
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override {fonts = ["Iosevka"];})
    maple-mono
  ];

  programs = {
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    teamviewer
    desktop-file-utils
    xdg-utils
    gnome-software
    # audio production
    pipewire.jack
    alsa-utils
    alsa-tools
    alsa-plugins
    alsa-firmware
    # scanner, printer
    qpdf
    imagemagick
    avahi
    sane-airscan
    brscan4
    brscan5
    # backups
    borgmatic
    # raid
    mdadm
    # devtools
    python3
    # chaotic stuff
    firefox_nightly
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [
    5353 # avahi deamon (printer/scanner)
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
