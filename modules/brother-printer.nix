{pkgs, ...}: let
  printerAddr = "192.168.1.11";
  printerName = "Brother_MFC_B7715DW";
in {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.addresses = true;
    publish.userServices = true;
  };
  services.udev.packages = [pkgs.sane-airscan];

  hardware.printers = {
    ensurePrinters = [
      {
        name = printerName;
        location = "Home";
        deviceUri = "ipp://${printerAddr}:631/ipp/print"; # Replace with your printer’s IP
        model = "everywhere"; # Use "everywhere" for IPP Everywhere or specify a PPD file
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = printerName;
  };
  # scanner, printer etc
  hardware.sane = {
    enable = true;
    disabledDefaultBackends = ["escl" "v4l"];
    extraBackends = [pkgs.sane-airscan];
    brscan4 = {
      enable = true;
      netDevices = {
        home = {
          model = printerName;
          ip = printerAddr;
        };
      };
    };
  };
  users.users.niedzwiedz.extraGroups = ["scanner" "lp"]; # Replace with your username
  environment.systemPackages = with pkgs; [xsane simple-scan];
}
