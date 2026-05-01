{pkgs, ...}: let
  displays = import ./available-displays--gpu-pc.nix;
  inherit (displays) iiyama lg aoc sony_tv;
  assignWorkspaces = import ./assign-workspaces.nix;
in {
  home.packages = with pkgs; [
    wl-mirror
  ];
  wayland.windowManager.sway = {
    extraConfig = ''
      # Put wl-mirror on workspace 99 and make it fullscreen
      workspace 99 output ${sony_tv.name}
      for_window [app_id="wl-mirror"] {
          move to workspace 99
          fullscreen enable
          floating enable
          sticky enable          # optional
      }

      # Prevent normal windows from going to workspace 99
      for_window [workspace="99"] move to output ${iiyama.name}
    '';

    config = {
      startup = [{command = "wl-mirror --fullscreen-output $mirror_output ${aoc.name}";}];
      workspaceOutputAssign =
        (assignWorkspaces lg [2 3 4])
        ++ (assignWorkspaces iiyama [1 5 6 7])
        ++ (assignWorkspaces aoc [8 9 10])
        ++ (assignWorkspaces sony_tv [99]);
      output = {
        "*" = {
          bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
        };
        # left
        ${lg.name} = {
          resolution = lg.resolution;
          position = "0,${toString (-350)}";
          # transform = "270";
        };
        # center
        ${iiyama.name} = {
          resolution = iiyama.resolution;
          position = "${toString lg.width},${toString 0}";
        };
        # aoc
        ${aoc.name} = {
          resolution = aoc.resolution;
          position = "${toString (lg.width + iiyama.width)},${toString (-350)}";
        };
        ${sony_tv.name} = {
          resolution = sony_tv.resolution;
          position = "${toString (lg.width + iiyama.width + 9000)},${toString 9000}";
          transform = toString 180;
        };
      };
    };
  };
}
