{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    difftastic
    gnupg
    pinentry-curses
  ];
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    difftastic = {
      enable = true;
      git.enable = true;
    };
  };

  xdg.configFile."~/.gitconfig".source = ./git/gitconfig.local;
}
