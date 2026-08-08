{
  pkgs,
  lib,
  ...
}: let
  displays = import ./available-displays--gpu-pc.nix;
  # inherit (displays) iiyama lg aoc sony_tv lg_tv;
  inherit (displays) iiyama lg aoc lg_tv;
  # assignWorkspacesSway = display: workspaces:
  #   map (n: {
  #     workspace = toString n;
  #     output = display.name;
  #   })
  #   workspaces;
  assignWorkspacesNiri = display: workspaces:
    lib.listToAttrs (map (n: {
        name = lib.fixedWidthNumber 2 n; # keys control ordering: "01" < "02" < "10"
        value = {
          name = toString n;
          open-on-output = display.name;
        };
      })
      workspaces);

  # scale now lives on each display; positions are logical (scaled) pixels,
  # so divide each output's physical width by its own scale.
  logicalWidth = d: builtins.floor (d.width / d.scale);
  # pos = x: y: "${toString x},${toString y}";

  lgLW = logicalWidth lg;
  iiyamaLW = logicalWidth iiyama;
in {
  # == SWAY ==
  # wayland.windowManager.sway = {
  #   config = {
  #     workspaceOutputAssign =
  #       (assignWorkspacesSway lg [2 3 4])
  #       ++ (assignWorkspacesSway iiyama [1 5 6 7])
  #       ++ (assignWorkspacesSway aoc [8 9 10])
  #       # ++ (assignWorkspaces sony_tv [99]);
  #       ++ (assignWorkspacesSway lg_tv [99]);
  #     output = {
  #       "*" = {
  #         bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
  #       };
  #       # left
  #       ${lg.name} = {
  #         resolution = lg.resolution;
  #         scale = toString lg.scale;
  #         position = pos 0 (-350);
  #       };
  #       # center
  #       ${iiyama.name} = {
  #         resolution = iiyama.resolution;
  #         scale = toString iiyama.scale;
  #         position = pos lgLW 0;
  #       };
  #       # right
  #       ${aoc.name} = {
  #         resolution = aoc.resolution;
  #         scale = toString aoc.scale;
  #         position = pos (lgLW + iiyamaLW) (-350);
  #       };
  #       # ${sony_tv.name} = {
  #       #   resolution = sony_tv.resolution;
  #       #   scale = toString sony_tv.scale;
  #       #   position = pos (lgLW + iiyamaLW + 9000) 9000;
  #       #   transform = toString 180;
  #       # };
  #       ${lg_tv.name} = {
  #         resolution = lg_tv.resolution;
  #         scale = toString lg_tv.scale;
  #         position = pos (lgLW + iiyamaLW + 9000) 9000;
  #         # transform = toString 180;
  #       };
  #     };
  #   };
  # };
  # == niri ==
  programs.niri.settings = {
    workspaces =
      (assignWorkspacesNiri lg [2 3 4])
      // (assignWorkspacesNiri iiyama [1 5 6 7])
      // (assignWorkspacesNiri aoc [8 9 10])
      # // (assignWorkspacesNiri sony_tv [99]);
      // (assignWorkspacesNiri lg_tv [99]);
    outputs = {
      # left
      ${lg.name} = {
        mode = {inherit (lg) width height;};
        scale = lg.scale;
        position = {
          x = 0;
          y = -350;
        };
      };
      # center
      ${iiyama.name} = {
        mode = {inherit (iiyama) width height;};
        scale = iiyama.scale;
        position = {
          x = lgLW;
          y = 0;
        };
      };
      # right
      ${aoc.name} = {
        mode = {inherit (aoc) width height;};
        scale = aoc.scale;
        position = {
          x = lgLW + iiyamaLW;
          y = -350;
        };
      };
      # ${sony_tv.name} = {
      #   mode = { inherit (sony_tv) width height ; };
      #   scale = sony_tv.scale;
      #   position = { x = lgLW + iiyamaLW + 9000; y = 9000; };
      #   transform.rotation = 180;
      # };
      ${lg_tv.name} = {
        mode = {inherit (lg_tv) width height;};
        scale = lg_tv.scale;
        position = {
          x = lgLW + iiyamaLW + 9000;
          y = 9000;
        };
        # transform.rotation = 180;
      };
    };

    spawn-at-startup = [
      {
        command = [
          "${pkgs.swaybg}/bin/swaybg"
          "-i"
          "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png"
          "-m"
          "fill"
        ];
      }
    ];
  };
}
