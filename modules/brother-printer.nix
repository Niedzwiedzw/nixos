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
  # services.udev.packages = [pkgs.sane-airscan];

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
  services.saned = {
    enable = true;
    extraConfig = "${printerAddr}";
  };
  hardware.sane = {
    enable = true;
    openFirewall = true;
    disabledDefaultBackends = [
      # "net"
      "abaton"
      "agfafocus"
      "apple"
      "artec"
      "artec_eplus48u"
      "as6e"
      "avision"
      "bh"
      "canon"
      "canon630u"
      "canon_dr"
      "canon_lide70"
      "cardscan"
      "coolscan"
      "coolscan3"
      "dell1600n_net"
      "dmc"
      "epjitsu"
      "epson2"
      "epsonds"
      "fujitsu"
      "genesys"
      "gt68xx"
      "hp"
      "hp3500"
      "hp3900"
      "hp4200"
      "hp5400"
      "hp5590"
      "hpljm1005"
      "hpsj5s"
      "hs2p"
      "ibm"
      "kodak"
      "kodakaio"
      "kvs1025"
      "kvs20xx"
      "kvs40xx"
      "leo"
      "lexmark"
      "ma1509"
      "magicolor"
      "matsushita"
      "microtek"
      "microtek2"
      "mustek"
      "mustek_usb"
      "mustek_usb2"
      "nec"
      "niash"
      "pie"
      "pieusb"
      "pint"
      "pixma"
      "plustek"
      "qcam"
      "ricoh"
      "ricoh2"
      "rts8891"
      "s9036"
      "sceptre"
      "sharp"
      "sm3600"
      "sm3840"
      "snapscan"
      "sp15c"
      "tamarack"
      "teco1"
      "teco2"
      "teco3"
      "u12"
      "umax"
      "umax1220u"
      "xerox_mfp"
      # "brother4"
    ];
    netConf = "${printerAddr}";
    # extraBackends = [pkgs.sane-airscan];
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
