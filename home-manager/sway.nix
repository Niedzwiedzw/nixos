{pkgs, ...}: {
  home.packages = with pkgs; [
    qt5.qtwayland
    waybar
    dmenu
    xorg.xrandr
    autotiling
    kooha
    wl-screenrec
    wf-recorder
    obs-studio
    obs-studio-plugins.obs-shaderfilter
    wl-clipboard
    grim
    swappy
    slurp
    pngquant
    alacritty
    emoji-picker
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.libglvnd}/lib";
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
      bindsym Mod4+Shift+x exec grim -g "$(slurp -d)" - | swappy -f - -o - | pngquant - | wl-copy -t image/png
      bindsym Mod4+Shift+w exec alacritty -e ep
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
        {command = "kdeconnect-app";}
      ];
      modifier = "Mod4";
      menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      terminal = "rio";
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
        # modules-left = ["sway/workspaces"];
        # modules-center = ["sway/window"];
        # modules-right = ["pulseaudio" "cpu" "memory" "temperature" "clock" "tray"];
        modules-left = ["sway/workspaces"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "cpu" "memory" "temperature" "network" "tray" "clock"];
        clock = {
          format = "🕗  {:%H:%M 📆  %a %Y-%m-%d}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        tray = {spacing = 6;};
        cpu = {
          format = "  {usage}% ({load})";
          interval = 5;
          states = {
            warning = 80;
            critical = 95;
          };
        };
        memory = {
          format = "🐏 {}%";
          interval = 5;
          states = {
            warning = 70;
            critical = 95;
          };
        };
        network = {
          interval = 5;
          "format-wifi" = "  {essid} ({signalStrength}%)"; # Icon= wifi
          "format-ethernet" = "🕸️  {ifname}: {ipaddr}/{cidr}"; #  Icon= ethernet
          "format-disconnected" = "⚠  Disconnected";
          "tooltip-format" = "{ifname}= {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = {
            default = ["" "" ""];
          };
        };

        "temperature" = {
          "critical-threshold" = 80;
          "interval" = 5;
          "format" = "{icon}  {temperatureC}°C";
          "format-icons" = [
            "" # Icon = temperature-empty
            "" # Icon = temperature-quarter
            "" # Icon = temperature-half
            "" # Icon = temperature-three-quarters
            "" # Icon = temperature-full
          ];
          "tooltip" = true;
        };
      }
    ];
    style = ''
                  * {
            	border: none;
            	border-radius: 10;
              font-family: "Cantarell, Noto Sans, sans-serif";
            	font-size: 15px;
            	min-height: 10px;
            }

            window#waybar {
            	background: transparent;
            }

            window#waybar.hidden {
            	opacity: 0.2;
            }

            #window {
            	margin-top: 6px;
            	padding-left: 10px;
            	padding-right: 10px;
            	border-radius: 10px;
            	transition: none;
                color: transparent;
            	background: transparent;
            }
            #tags {
            	margin-top: 6px;
            	margin-left: 12px;
            	font-size: 4px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	background: #161320;
            	transition: none;
            }

            #tags button {
            	transition: none;
            	color: #B5E8E0;
            	background: transparent;
            	font-size: 16px;
            	border-radius: 2px;
            }

            #tags button.occupied {
            	transition: none;
            	color: #F28FAD;
            	background: transparent;
            	font-size: 4px;
            }

            #tags button.focused {
            	color: #ABE9B3;
                border-top: 2px solid #ABE9B3;
                border-bottom: 2px solid #ABE9B3;
            }

            #tags button:hover {
            	transition: none;
            	box-shadow: inherit;
            	text-shadow: inherit;
            	color: #FAE3B0;
                border-color: #E8A2AF;
                color: #E8A2AF;
            }

            #tags button.focused:hover {
                color: #E8A2AF;
            }

            #network {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #bd93f9;
            }

            #pulseaudio {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #1A1826;
            	background: #FAE3B0;
            }

            #battery {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #B5E8E0;
            }

            #battery.charging, #battery.plugged {
            	color: #161320;
                background-color: #B5E8E0;
            }

            #battery.critical:not(.charging) {
                background-color: #B5E8E0;
                color: #161320;
                animation-name: blink;
                animation-duration: 0.5s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
            }

            @keyframes blink {
                to {
                    background-color: #BF616A;
                    color: #B5E8E0;
                }
            }

            #backlight {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #F8BD96;
            }
            #clock {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #ABE9B3;
            	/*background: #1A1826;*/
            }

            #memory {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	margin-bottom: 0px;
            	padding-right: 10px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #DDB6F2;
            }
            #cpu {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	margin-bottom: 0px;
            	padding-right: 10px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #96CDFB;
            }

            #tray {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	margin-bottom: 0px;
            	padding-right: 10px;
            	border-radius: 10px;
            	transition: none;
            	color: #B5E8E0;
            	background: #161320;
            }

            #custom-launcher {
            	font-size: 24px;
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 5px;
            	border-radius: 10px;
            	transition: none;
                color: #89DCEB;
                background: #161320;
            }

            #custom-power {
            	font-size: 20px;
            	margin-top: 6px;
            	margin-left: 8px;
            	margin-right: 8px;
            	padding-left: 10px;
            	padding-right: 5px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #F28FAD;
            }

            #custom-wallpaper {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #C9CBFF;
            }

            #custom-updates {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #E8A2AF;
            }

            #custom-media {
            	margin-top: 6px;
            	margin-left: 8px;
            	padding-left: 10px;
            	padding-right: 10px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #F2CDCD;
            }


            #workspaces button {
          border-top: 2px solid transparent;
          /* To compensate for the top border and still have vertical centering */
          padding-bottom: 2px;
          padding-left: 10px;
          padding-right: 10px;
          color: #888888;
      }

      #workspaces button.focused {
          border-color: #4c7899;
          color: white;
          background-color: #285577;
      }

      #workspaces button.urgent {
          border-color: #c9545d;
          color: #c9545d;
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
