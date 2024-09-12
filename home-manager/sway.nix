{pkgs, ...}: {
  home.packages = with pkgs; [
    qt5.qtwayland
    waybar
    dmenu
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XKB_DEFAULT_OPTIONS = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
    SDL_VIDEODRIVER = "wayland";

    # needs qt5.qtwayland in systemPackages
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Fix for some Java AWT applications (e.g. Android Studio),
    # use this if they aren't displayed properly:
    _JAVA_AWT_WM_NONREPARENTING = 1;

    # gtk applications on wayland
    GTK_BACKEND = "wayland";
  };

  wayland.windowManager.sway = {
    checkConfig = false;
    enable = true;
    extraConfig = ''
      # catpuccin mocha: https://github.com/catppuccin/i3/blob/main/themes/catppuccin-mocha
      set $rosewater #f5e0dc
      set $flamingo #f2cdcd
      set $pink #f5c2e7
      set $mauve #cba6f7
      set $red #f38ba8
      set $maroon #eba0ac
      set $peach #fab387
      set $yellow #f9e2af
      set $green #a6e3a1
      set $teal #94e2d5
      set $sky #89dceb
      set $sapphire #74c7ec
      set $blue #89b4fa
      set $lavender #b4befe
      set $text #cdd6f4
      set $subtext1 #bac2de
      set $subtext0 #a6adc8
      set $overlay2 #9399b2
      set $overlay1 #7f849c
      set $overlay0 #6c7086
      set $surface2 #585b70
      set $surface1 #45475a
      set $surface0 #313244
      set $base #1e1e2e
      set $mantle #181825
      set $crust #11111b


      # target                 title     bg    text   indicator  border
      client.focused           $lavender $base $text  $rosewater $lavender
      client.focused_inactive  $overlay0 $base $text  $rosewater $overlay0
      client.unfocused         $overlay0 $base $text  $rosewater $overlay0
      client.urgent            $peach    $base $peach $overlay0  $peach
      client.placeholder       $overlay0 $base $text  $overlay0  $overlay0
      client.background        $base

      # bar
      bar {
        colors {
          background         $base
          statusline         $text
          focused_statusline $text
          focused_separator  $base

          # target           border bg        text
          focused_workspace  $base  $mauve    $crust
          active_workspace   $base  $surface2 $text
          inactive_workspace $base  $base     $text
          urgent_workspace   $base  $red      $crust
        }
      }
      # wallpaper
      output * bg /home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill
    '';

    config = {
      modifier = "Mod4";
      menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      terminal = "wezterm";

      input = {
        "*" = {
          xkb_layout = "pl";
        };
      };

      bars = [
        {
          "command" = "${pkgs.waybar}/bin/waybar";
        }
      ];

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "DP-2";
        }
        {
          workspace = "2";
          output = "DP-2";
        }
        {
          workspace = "3";
          output = "DP-2";
        }
        {
          workspace = "4";
          output = "HDMI-A-1";
        }
        {
          workspace = "5";
          output = "HDMI-A-1";
        }
        {
          workspace = "6";
          output = "HDMI-A-1";
        }
        {
          workspace = "7";
          output = "HDMI-A-1";
        }
        {
          workspace = "8";
          output = "HDMI-A-2";
        }
        {
          workspace = "9";
          output = "HDMI-A-2";
        }
        {
          workspace = "10";
          output = "HDMI-A-2";
        }
      ];
      output = {
        "*" = {
          bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
        };
        "DP-2" = {
          resolution = "1920x1080@144hz";
          position = "0,295";
        };
        "HDMI-A-1" = {
          resolution = "2560x1440@144hz";
          position = "1920,0";
        };
        "HDMI-A-2" = {
          resolution = "1920x1080@144hz";
          position = "4480,460";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = ["sway/workspaces"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "cpu" "memory" "temperature" "clock" "tray"];
        clock.format = "{:%Y-%m-%d %H:%M}";
        "tray" = {spacing = 8;};
        "cpu" = {format = "cpu {usage}";};
        "memory" = {format = "mem {}";};
        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp2_input";
          format = "tmp {temperatureC}C";
        };
        "pulseaudio" = {
          format = "vol {volume} {format_source}";
          format-bluetooth = "volb {volume} {format_source}";
          format-bluetooth-muted = "volb {format_source}";
          format-muted = "vol {format_source}";
          format-source = "mic {volume}";
          format-source-muted = "mic";
        };
      }
    ];
    style = let
      makeBorder = color: "border-bottom: 3px solid #${color};";
      makeInfo = color: ''
        color: #${color};
        ${makeBorder color}
      '';
      colorSchemeDark = rec {
        primary = {
          normal = {
            background = "181818";
            foreground = "b9b9b9";
          };
          bright = {
            background = bright.black;
            foreground = bright.white;
          };
        };
        normal = {
          black = "252525";
          gray = "5b5b5b";
          red = "ed4a46";
          green = "70b433";
          yellow = "dbb32d";
          blue = "368aeb";
          magenta = "eb6eb7";
          cyan = "3fc5b7";
          white = "777777";
        };
        bright = {
          black = "3b3b3b";
          gray = "7b7b7b";
          red = "ff5e56";
          green = "83c746";
          yellow = "efc541";
          blue = "4f9cfe";
          magenta = "ff81ca";
          cyan = "56d8c9";
          white = "dedede";
        };
      };

      bgColor = colorScheme.primary.normal.background;
      fgColor = colorScheme.primary.bright.foreground;
      acColor = colorScheme.normal.red;

      colorScheme = colorSchemeDark;
      font = "Iosevka Nerd Font Mono";

      clockColor = colorScheme.bright.magenta;
      cpuColor = colorScheme.bright.green;
      memColor = colorScheme.bright.blue;
      pulseColor = {
        normal = colorScheme.bright.cyan;
        muted = colorScheme.bright.gray;
      };
      tmpColor = {
        normal = colorScheme.bright.yellow;
        critical = colorScheme.bright.red;
      };
    in ''
      * {
          border: none;
          border-radius: 0;
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: ${font};
          font-size: 16px;
          min-height: 0;
      }
      window#waybar {
          background-color: #${bgColor};
          /* border-bottom: 0px solid rgba(100, 114, 125, 0.5); */
          color: #${fgColor};
          transition-property: background-color;
          transition-duration: .5s;
      }
      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #${fgColor};
          border-bottom: 3px solid transparent;
      }
      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          box-shadow: inherit;
          border-bottom: 3px solid #ffffff;
      }
      #workspaces button.focused {
          border-bottom: 3px solid #${acColor};
      }
      #workspaces button.urgent {
          background-color: #${acColor};
          color: #${bgColor};
      }
      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
          padding: 0 10px;
          margin: 0 4px;
          background-color: transparent;
          ${makeInfo fgColor}
      }
      label:focus {
          color: #000000;
      }
      #clock {
          ${makeInfo clockColor}
      }
      #cpu {
          ${makeInfo cpuColor}
      }
      #memory {
          ${makeInfo memColor}
      }
      #pulseaudio {
          ${makeInfo pulseColor.normal}
      }
      #pulseaudio.muted {
          ${makeInfo pulseColor.muted}
      }
      #temperature {
          ${makeInfo tmpColor.normal}
      }
      #temperature.critical {
          ${makeInfo tmpColor.critical}
      }
    '';
  };

  xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    [screencast]
    output_name=
    max_fps=30
    chooser_cmd=${pkgs.slurp}/bin/slurp -f %o -or
    chooser_type=simple
  '';
}
