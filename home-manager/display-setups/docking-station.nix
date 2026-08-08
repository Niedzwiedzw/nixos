{
  lib,
  pkgs,
  ...
}: let
  displays = import ./available-displays--thinkpad.nix;
  inherit (displays) thinkpad iiyama lg aoc;
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
in {
  # wayland.windowManager.sway.config = {
  #   workspaceOutputAssign =
  #     (assignWorkspacesSway thinkpad [1])
  #     ++ (assignWorkspacesSway lg [2 3 4])
  #     ++ (assignWorkspacesSway iiyama [5 6 7])
  #     ++ (assignWorkspacesSway aoc [8 9 10]);
  #   output = {
  #     "*" = {
  #       bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
  #     };
  #     ${thinkpad.name} = {
  #       resolution = thinkpad.resolution;
  #       position = "${toString lg.width},${toString (iiyama.height)}";
  #     };
  #     # left
  #     ${lg.name} = {
  #       resolution = lg.resolution;
  #       position = "0,${toString (-350)}";
  #       # transform = "270";
  #     };
  #     # center
  #     ${iiyama.name} = {
  #       resolution = iiyama.resolution;
  #       position = "${toString lg.width},${toString 0}";
  #     };
  #     # aoc
  #     ${aoc.name} = {
  #       resolution = aoc.resolution;
  #       position = "${toString (lg.width + iiyama.width)},${toString (-350)}";
  #     };
  #   };
  # };
  programs.niri.settings = {
    workspaces =
      (assignWorkspacesNiri thinkpad [1])
      // (assignWorkspacesNiri lg [2 3 4])
      // (assignWorkspacesNiri iiyama [5 6 7])
      // (assignWorkspacesNiri aoc [8 9 10]);
    outputs = {
      ${thinkpad.name} = {
        mode = {inherit (thinkpad) width height;};
        position = {
          x = lg.width;
          y = iiyama.height;
        };
      };
      # left
      ${lg.name} = {
        mode = {inherit (lg) width height;};
        position = {
          x = 0;
          y = -350;
        };
        # transform.rotation = 270;
      };
      # center
      ${iiyama.name} = {
        mode = {inherit (iiyama) width height;};
        position = {
          x = lg.width;
          y = 0;
        };
      };
      # aoc
      ${aoc.name} = {
        mode = {inherit (aoc) width height;};
        position = {
          x = lg.width + iiyama.width;
          y = -350;
        };
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
