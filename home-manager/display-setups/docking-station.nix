{...}: let
  displays = import ./available-displays.nix;
  inherit (displays) laptop leftMonitor centerMonitor rightMonitor;
  assignWorkspaces = import ./assign-workspaces.nix;
in {
  wayland.windowManager.sway.config = {
    workspaceOutputAssign =
      (assignWorkspaces leftMonitor [1 2 3])
      ++ (assignWorkspaces centerMonitor [4 5 6 7])
      ++ (assignWorkspaces rightMonitor [8 9 10]);
    output = {
      ${laptop.name} = {
        resolution = laptop.resolution;
      };
      "*" = {
        bg = "/home/niedzwiedz/nixos/my-wallpaper-malysz-tajner-chester-linkin-park.png fill";
      };
      ${leftMonitor.name} = {
        resolution = leftMonitor.resolution;
        position = "0,295";
        # transform = "270";
      };
      ${centerMonitor.name} = {
        resolution = centerMonitor.resolution;
        position = "1920,0";
      };
      ${rightMonitor.name} = {
        resolution = rightMonitor.resolution;
        position = "4480,460";
      };
    };
  };
}
