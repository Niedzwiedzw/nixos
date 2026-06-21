{...}: {
  musnix = {
    rtcqs.enable = true;
    rtirq = {
      enable = true;
      resetAll = 1;
      prioLow = 0;
      nameList = "rtc0 xhci_hcd snd";
    };
  };
}
