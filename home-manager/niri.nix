{
  pkgs,
  lib,
  startupPrograms,
  ...
}: {
  programs.niri = {
    enable = true;
    settings = {
      input.focus-follows-mouse = {};
      spawn-at-startup = map (it: {command = ["sh" "-c" it];}) startupPrograms;
      hotkey-overlay = {
        skip-at-startup = true;
      };

      cursor = {
        hide-when-typing = true;
        hide-after-inactive-ms = 1000;
      };

      input.keyboard.xkb = {
        layout = "pl";
        # options = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
      };

      # catppuccin
      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active.color = "#b4befe"; # lavender
          inactive.color = "#6c7086"; # overlay0
        };
      };

      binds =
        {
          # -- apps --
          "Mod+Return".action.spawn = "rio";
          # "Mod+D".action.spawn = "/home/niedzwiedz/nixos/scripts/dmenu-wrapped.sh";
          "Mod+D".action.spawn = "${pkgs.fuzzel}/bin/fuzzel";
          "Mod+Shift+Q".action.close-window = {};

          # -- focus --
          "Mod+H".action.focus-column-or-monitor-left = {};
          "Mod+L".action.focus-column-or-monitor-right = {};
          "Mod+Shift+H".action.move-column-to-monitor-left = {};
          "Mod+Shift+L".action.move-column-to-monitor-right = {};

          "Mod+J".action.focus-window-or-monitor-down = {};
          "Mod+K".action.focus-window-or-monitor-up = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Shift+K".action.move-window-up = {};

          "Mod+Ctrl+J".action.focus-monitor-down = {};
          "Mod+Ctrl+K".action.focus-monitor-up = {};
          "Mod+Ctrl+Shift+J".action.move-column-to-monitor-down = {};
          "Mod+Ctrl+Shift+K".action.move-column-to-monitor-up = {};

          # -- monitors (extra vs sway, since columns scroll within a monitor) --
          "Mod+Ctrl+H".action.focus-monitor-left = {};
          "Mod+Ctrl+L".action.focus-monitor-right = {};
          "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = {};
          "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = {};

          # -- windows/layout --
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+Shift+Space".action.toggle-window-floating = {};
          "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
          "Mod+R".action.switch-preset-column-width = {};
          "Mod+Shift+R".action.switch-preset-window-height = {};
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Comma".action.consume-window-into-column = {}; # ~ sway "move into container"
          "Mod+Period".action.expel-window-from-column = {};
          "Mod+W".action.toggle-column-tabbed-display = {}; # ~ sway tabbed layout

          # -- misc --
          "Mod+Tab".action.toggle-overview = {};
          "Mod+Shift+E".action.quit = {};
          "Ctrl+Alt+L".action.spawn = "swaylock";
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};

          "Mod+C".action.center-column = {};
          "Mod+Home".action.focus-column-first = {};
          "Mod+End".action.focus-column-last = {};
          "Print".action.screenshot = {};
          "Alt+Print".action.screenshot-window = {};
          "Mod+Shift+Equal".action.expand-column-to-available-width = {};

          # screenshots
          "Mod+Shift+X".action.spawn = ["sh" "-c" ''grim -g "$(slurp -d)" - | swappy -f - -o - | pngquant - | tee /tmp/screenshot.png | wl-copy -t image/png''];
          "Mod+Shift+V".action.spawn = ["sh" "-c" ''grim -g "$(slurp -d)" - | convert - -resize 300% -sharpen 0x1.0 - | tesseract stdin stdout -l eng+pol | wl-copy''];
          "Mod+Shift+W".action.spawn = ["alacritty" "-e" "ep"];
        }
        # -- workspaces 1-10 + 99, by name (matches your pinned named workspaces) --
        // lib.listToAttrs (lib.concatMap (n: let
          ws = toString n;
          key = toString (lib.mod n 10);
        in [
          {
            name = "Mod+${key}";
            value.action.focus-workspace = ws;
          }
          {
            name = "Mod+Shift+${key}";
            value.action.move-column-to-workspace = ws;
          }
        ]) (lib.range 1 10))
        // {
          "Mod+Grave".action.focus-workspace = "99"; # the TV
          "Mod+Shift+Grave".action.move-column-to-workspace = "99";
        };

      environment = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        SDL_VIDEODRIVER = "wayland";

        # needs qt5.qtwayland in packages
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "rio";
        font = "Maple Mono NF:size=12";
      };
      # catppuccin mocha, to match the borders
      colors = {
        background = "1e1e2eff"; # base
        text = "cdd6f4ff"; # text
        match = "b4befeff"; # lavender
        selection = "45475aff"; # surface1
        selection-text = "cdd6f4ff";
        selection-match = "b4befeff";
        border = "b4befeff"; # lavender
      };
    };
  };

  programs = {
    alacritty.enable = true;
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        effect-blur = "20x2";
        fade-in = "0.5";
        font = "Maple Mono NF";
        indicator-radius = 100;
        indicator-thickness = 7;
      };
    };
  };

  services = {
    swaync.enable = true; # notification daemon (waybar custom/notification uses swaync-client)
    swayidle.enable = true; # idle management daemon (TODO: configure timeouts/events)
    # polkit-gnome.enable = true; # polkit
    # NOTE: if using niri-flake's NixOS module, it already runs the KDE polkit
    # agent; disable one of them, e.g. on the NixOS side:
    #   systemd.user.services.niri-flake-polkit.enable = false;
  };

  home.packages = with pkgs; [
    swaybg # wallpaper
    xwayland-satellite # xwayland support (niri >= 25.05 auto-spawns it from PATH)
    networkmanagerapplet
    qt5.qtwayland
    xorg.xrandr
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

    # ocr
    tesseract
    imagemagick
    # bluetooth
    overskride
    wl-mirror
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };

  # == waybar ==
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        # sway/* modules populate under sway, niri/* under niri;
        # waybar silently skips the inactive ones.
        modules-left = ["sway/workspaces" "niri/workspaces"];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "99" = "📺";
            default = "•";
          };
        };
        modules-center = ["sway/window" "niri/window"];
        modules-right = ["cpu" "memory" "temperature#cpu" "temperature#gpu" "network" "clock" "idle_inhibitor" "custom/lock" "custom/notification" "battery" "tray"];
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "custom/lock" = {
          format = "";
          on-click = "swaylock";
          tooltip = true;
        };
        clock = {
          format = "🕗  {:%H:%M 📆  %a %Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        tray = {spacing = 5;};
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
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
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 1;
          };
          "format" = "<span color='#28CD41'> {icon} </span>{capacity}% ";
          "format-charging" = " 󱐋{capacity}%";
          "interval" = 1;
          "format-icons" = ["󰂎" "󰁼" "󰁿" "󰂁" "󰁹"];
          "tooltip" = true;
        };

        "temperature#cpu" = {
          critical-threshold = 80;
          interval = 5;
          format = "{icon} CPU {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          format-icons = [
            "" # temperature-empty
            "" # temperature-quarter
            "" # temperature-half
            "" # temperature-three-quarters
            "" # temperature-full
          ];
          tooltip = true;
        };
        "temperature#gpu" = {
          critical-threshold = 80;
          interval = 5;
          format = "{icon} GPU {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          format-icons = [
            "" # temperature-empty
            "" # temperature-quarter
            "" # temperature-half
            "" # temperature-three-quarters
            "" # temperature-full
          ];
          tooltip = true;
        };
      }
    ];
    style = ''
            * {
            	border: none;
            	border-radius: 10;
              font-family: "Maple Mono NF";
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
            }
            #custom-notification {
            	margin-top: 6px;
            	margin-left: 8px;
            	margin-right: 4px;
            	padding-left: 10px;
            	padding-right: 15px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #E8A2AF;
            }
            #custom-lock {
            	margin-top: 6px;
            	margin-left: 8px;
            	margin-right: 4px;
            	padding-left: 10px;
            	padding-right: 15px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #E8A2AF;
            }
            #idle_inhibitor {
            	margin-top: 6px;
            	margin-left: 8px;
            	margin-right: 4px;
            	padding-left: 10px;
            	padding-right: 15px;
            	margin-bottom: 0px;
            	border-radius: 10px;
            	transition: none;
            	color: #161320;
            	background: #E8A2AF;
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
            #temperature {
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

      #workspaces button.empty {
          color: #45475a;
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
}
