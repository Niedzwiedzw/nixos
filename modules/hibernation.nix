{pkgs, ...}: let
  rootUUID = "5c5c04d6-36cb-48e5-aa18-201254f0d95d";
  swapUUID = "58e44a76-a337-43cc-97ff-adf1528670b2";
in {
  powerManagement.enable = true;
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/${swapUUID}";
    }
  ]; # 16GB swap file
  boot.kernelParams = ["mem_sleep_default=deep"]; # Replace 123456 with your swap offset
  boot.resumeDevice = "/dev/disk/by-uuid/${rootUUID}"; # Replace with your root UUID
  services.logind.powerKey = "hibernate"; # Power button triggers hibernation
  services.logind.powerKeyLongPress = "poweroff"; # Long press powers off
  environment.systemPackages = with pkgs; [swayidle swaylock];
}
