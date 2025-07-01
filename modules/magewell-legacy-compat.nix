{inputs, ...}: {
  # magewell capture card
  hardware.mwProCapture.enable = true;

  # tiktok
  boot.kernelModules = [
    "v4l2loopback"
  ];
  boot.kernelPackages =
    (import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      system = "x86_64-linux";
    }).linuxPackages_6_12;
}
