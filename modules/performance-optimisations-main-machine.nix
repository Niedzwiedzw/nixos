{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    # AMD P-State EPP driver
    # (Modern frequency driver for 7800X3D)
    "amd_pstate=guided"

    # Reduce verbosity for faster boot
    "quiet"
    "loglevel=3"
    "usbcore.autosuspend=-1"
  ];
  boot.loader.timeout = 1;

  services.udev.extraRules = ''
    # NVMe drives: use 'none' for lowest latency
    ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"
  '';

  boot.kernel.sysctl = {
    # Keep inode/dentry caches longer
    "vm.vfs_cache_pressure" = 50;

    # Writeback tuning for better responsiveness
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    # Increase max memory map areas (helps with some games/apps)
    "vm.max_map_count" = 2147483642;

    # ─── Network tuning (for online gaming) ───
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
  };

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
}
