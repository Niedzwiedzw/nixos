{...}: let
  displays = import ./available-displays--gpu-pc.nix;
  inherit (displays) iiyama lg aoc sony_tv;
  assignWorkspaces = import ./assign-workspaces.nix;

  # scale now lives on each display; positions are logical (scaled) pixels,
  # so divide each output's physical width by its own scale.
  logicalWidth = d: builtins.floor (d.width / d.scale);
  pos = x: y: "${toString x},${toString y}";

  lgLW = logicalWidth lg;
  iiyamaLW = logicalWidth iiyama;
in {
  wayland.windowManager.sway = {
    config = {
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
          scale = toString lg.scale;
          position = pos 0 (-350);
        };
        # center
        ${iiyama.name} = {
          resolution = iiyama.resolution;
          scale = toString iiyama.scale;
          position = pos lgLW 0;
        };
        # right
        ${aoc.name} = {
          resolution = aoc.resolution;
          scale = toString aoc.scale;
          position = pos (lgLW + iiyamaLW) (-350);
        };
        ${sony_tv.name} = {
          resolution = sony_tv.resolution;
          scale = toString sony_tv.scale;
          position = pos (lgLW + iiyamaLW + 9000) 9000;
          transform = toString 180;
        };
      };
    };
  };
}
