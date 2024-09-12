{pkgs, ...}: {
  home.packages = with pkgs; [
    qt5.qtwayland
    waybar
    dmenu
    xorg.xrandr
    autotiling
    kooha
    wl-clipboard
    grim
    swappy
    slurp
    pngquant
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
    systemd.enable = true;
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

      # wallpaper
      output * bg /home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill

      # keybinds
      bindsym $mod+Shift+x exec grim -g "$(slurp)" - | swappy -f - -o - | pngquant - | wl-copy


    '';

    config = {
      startup = [
        {command = "signal-desktop";}
        {command = "betterbird";}
        {command = "slack";}
        {command = "discord";}
        {command = "keepassxc";}
        {command = "xrandr --output HDMI-A-1 --primary";}
        {command = "thunderbird";}
        {command = "autotiling";}
      ];
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
  services.swaync = {
    enable = true;
  };
  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
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
    style = ''
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      * {
        /* reference the color by using @color-name */
        color: @text;
      }

      window#waybar {
        /* you can also GTK3 CSS functions! */
        background-color: shade(@base, 0.9);
      }
      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: white;
      }

      #workspaces button.focused {
          background: @mantle;
      }
      label.module {
        padding: 0 10px;
      }
      box.module button:hover {
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
