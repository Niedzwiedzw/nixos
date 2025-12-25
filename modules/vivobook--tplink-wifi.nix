{...}: {
  boot = {
    # kernelModules = ["8192eu"];
    # blacklistedKernelModules = ["rtl8xxxu"];
  };
  networking = {
    # wireless.enable = true;
    networkmanager.enable = true;
  };
  programs.nm-applet.enable = true;
}
