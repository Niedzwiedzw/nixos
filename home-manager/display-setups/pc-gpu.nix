{...}: {
  wayland.windowManager.sway.config = {
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
      "eDP-1" = {
        resolution = "1920x1200@60hz";
      };
      "*" = {
        bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
      };
      "DP-2" = {
        resolution = "1920x1080@144hz";
        position = "0,295";
        # transform = "270";
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
}
