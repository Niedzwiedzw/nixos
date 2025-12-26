{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    difftastic
    gnupg
    pinentry-curses
  ];
  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;
  };

  xdg.configFile."~/.gitconfig".source = ./git/gitconfig.local;
}
