{pkgs, ...}: {
  home.packages = with pkgs; [
    thunderbird
  ];
  programs.thunderbird = {
    enable = true;
  };
}
