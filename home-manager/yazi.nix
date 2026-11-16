{ yaziPluginsSource, ... }: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;

    plugins.zoom = "${yaziPluginsSource}/zoom.yazi";

    keymap.mgr.prepend_keymap = [
      {
        on = "+";
        run = "plugin zoom 1";
        desc = "Zoom in";
      }
      {
        on = "-";
        run = "plugin zoom -1";
        desc = "Zoom out";
      }
    ];
  };
}
