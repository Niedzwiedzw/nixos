{...}: {
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "16G";

  # -- BLEEDING EDGE STARTS HERE ---
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd"; # Steam Deck's choice
  services.ananicy.enable = false; # Disable - conflicts with sched-ext

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEMD-OOMD - Better OOM handling than kernel default
  # ═══════════════════════════════════════════════════════════════════════════
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  # enable low efvenrgy consumption mode
  services.thermald.enable = true;
  powerManagement = {
    enable = true;
    powertop = {
      enable = true;
    };
  };
  # Disable USB autosuspend globally
  boot.kernelParams = ["usbcore.autosuspend=-1"];
}
