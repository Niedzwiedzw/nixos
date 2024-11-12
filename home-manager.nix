{
  pkgs,
  helix-flake,
  lib,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  # CATPUCCIN
  catppuccin = {
    enable = true;
    flavor = "mocha";
    pointerCursor.enable = true;
  };
  gtk.catppuccin.enable = true;
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
      busybox
      libreoffice
      # rest
      davinci-resolve
      gimp
      anydesk
      aseprite
      firefox
      ffmpeg-full
      reaper
      evince
      wezterm
      xfce.thunar
      keepassxc
      discord
      ungoogled-chromium
      slack
      steam
      (lutris.override {
        extraLibraries = pkgs: [
          pkgsi686Linux.libglvnd # 32-bit OpenGL compatibility libraries
          pkgsi686Linux.openalSoft # 32-bit OpenAL library
        ];
      })
      signal-desktop
      bacon
      nil
      nixpkgs-fmt
      alejandra
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
      rust-analyzer
      #  thunderbird
      adw-gtk3
    ];
  };
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  programs = {
    zellij = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
      };
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        -- Pull in the wezterm API
        local wezterm = require 'wezterm'

        -- This will hold the configuration.
        local config = wezterm.config_builder()

        -- This is where you actually apply your config choices

        -- For example, changing the color scheme:
        config.color_scheme = 'Catppuccin Mocha';
        config.font = wezterm.font("Iosevka Nerd Font Mono", {weight="Medium", stretch="Normal", style="Normal"});
        config.enable_tab_bar = false;
        config.front_end = "WebGpu";
        config.scrollback_lines = 100000
        config.window_background_opacity = 0.88;
        config.font_size = 14;

        config.window_background_gradient = {
          -- Can be "Vertical" or "Horizontal".  Specifies the direction
          -- in which the color gradient varies.  The default is "Horizontal",
          -- with the gradient going from left-to-right.
          -- Linear and Radial gradients are also supported; see the other
          -- examples below
          orientation = 'Vertical',

          -- Specifies the set of colors that are interpolated in the gradient.
          -- Accepts CSS style color specs, from named colors, through rgb
          -- strings and more
          colors = {
            '#180101',
            '#241200',
          },

          -- Instead of specifying `colors`, you can use one of a number of
          -- predefined, preset gradients.
          -- A list of presets is shown in a section below.
          -- preset = "Warm",

          -- Specifies the interpolation style to be used.
          -- "Linear", "Basis" and "CatmullRom" as supported.
          -- The default is "Linear".
          interpolation = 'Linear',

          -- How the colors are blended in the gradient.
          -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
          -- The default is "Rgb".
          blend = 'Rgb',

          -- To avoid vertical color banding for horizontal gradients, the
          -- gradient position is randomly shifted by up to the `noise` value
          -- for each pixel.
          -- Smaller values, or 0, will make bands more prominent.
          -- The default value is 64 which gives decent looking results
          -- on a retina macbook pro display.
          -- noise = 64,

          -- By default, the gradient smoothly transitions between the colors.
          -- You can adjust the sharpness by specifying the segment_size and
          -- segment_smoothness parameters.
          -- segment_size configures how many segments are present.
          -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
          -- 1.0 is a soft edge.

          -- segment_size = 11,
          -- segment_smoothness = 0.0,
        }


        -- and finally, return the configuration to wezterm
        return config
      '';
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
    helix = {
      package = helix-flake.packages.${pkgs.system}.default;
      enable = true;
      defaultEditor = true;
      settings = {
        theme = lib.mkForce "kanagawa";

        editor = {
          auto-completion = false;
          auto-format = true;
          scrolloff = 10;
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          true-color = true;
          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "disable";
          };
          search = {
            wrap-around = true;
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "block";
          };
          indent-guides = {
            render = true;
            character = "·";
          };
          file-picker.hidden = false;
        };
        keys = {
          normal = {
            space = {
              "e" = ":reload-all";
              "L" = ":lsp-restart";
              "I" = ":toggle-option lsp.display-inlay-hints";
              "O" = ":toggle inline-diagnostics.cursor-line disable warning";
            };
          };
          insert = {
            C-a = "goto_first_nonwhitespace";
            C-e = "goto_line_end_newline";
          };
          select = {
            esc = ["normal_mode"];
          };
        };
      };
      languages = {
        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
          }
          {
            name = "toml";
            auto-format = true;
          }
          {
            name = "typst";
            language-servers = ["tinymist"];
          }
        ];
        language-server.rust-analyzer = {
          command = "rust-analyzer";
          config = {
            command = "clippy";
            checkOnSave.command = "clippy";
          };
        };
        language-server.tinymist.command = "tinymist";
        language-server.nil = {
          command = "nil";
          config = {
            nix = {
              flake = {
                autoEvalInputs = true;
                autoArchive = true;
              };
              maxMemoryMB = 8192;
            };
            formatting.command = ["alejandra" "--"];
          };
        };
      };
    };
  };
  imports = [
    ./home-manager/thunderbird.nix
    ./home-manager/sway.nix
    ./home-manager/fish.nix
    ./home-manager/git.nix
  ];
}
