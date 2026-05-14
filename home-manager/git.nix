{pkgs, ...}: {
  home.packages = with pkgs; [
    git
    difftastic
    gnupg
    pinentry-curses
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true; # note: lowercase 'p' in Support
  };
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
