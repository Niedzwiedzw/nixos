{...}: let
  displays = import ./available-displays.nix;
  inherit (displays) thinkpad iiyama lg aoc;
  assignWorkspaces = import ./assign-workspaces.nix;
in {
  wayland.windowManager.sway.config = {
    workspaceOutputAssign =
      (assignWorkspaces thinkpad [1])
      ++ (assignWorkspaces lg [2 3 4])
      ++ (assignWorkspaces iiyama [5 6 7])
      ++ (assignWorkspaces aoc [8 9 10]);
    output = {
      "*" = {
        bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
      };
      ${thinkpad.name} = {
        resolution = thinkpad.resolution;
        position = "${toString lg.width},0";
      };
      # left
      ${lg.name} = {
        resolution = lg.resolution;
        position = "0,${toString (thinkpad.height + 350)}";
        # transform = "270";
      };
      # center
      ${iiyama.name} = {
        resolution = iiyama.resolution;
        position = "${toString lg.width},${toString thinkpad.height}";
      };
      # aoc
      ${aoc.name} = {
        resolution = aoc.resolution;
        position = "${toString (lg.width + iiyama.width)},${toString (thinkpad.height + 350)}";
      };
    };
  };
}
