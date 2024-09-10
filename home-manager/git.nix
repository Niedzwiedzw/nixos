{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    difftastic
    gnupg
    pinentry
  ];
  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;
  };

  xdg.configFile."~/.gitconfig".source = ./git/gitconfig.local;
}
