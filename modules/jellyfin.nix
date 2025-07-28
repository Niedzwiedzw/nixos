{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "niedzwiedz";
    group = "users";
  };
  services.minidlna = {
    enable = true;
    settings = {
      media_dir = ["/home/niedzwiedz/Downloads/torrent"];
      friendly_name = "NixOS Media Server";
      inotify = "yes"; # Auto-detect new files
    };
  };
  environment.systemPackages = with pkgs; [ffmpeg libva libva-utils];
}
