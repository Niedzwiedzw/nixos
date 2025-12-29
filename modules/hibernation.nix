{pkgs, ...}: let
  swapUUID = "58e44a76-a337-43cc-97ff-adf1528670b2";
in {
  powerManagement.enable = true;
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/${swapUUID}";
    }
  ];
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "resume=/dev/disk/by-uuid/${swapUUID}"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/${swapUUID}";
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";
  environment.systemPackages = with pkgs; [swayidle swaylock];
}
