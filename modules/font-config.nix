{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome_6 # or font-awesome_5
      material-design-icons
      noto-fonts-color-emoji # for emoji support
      noto-fonts
      noto-fonts-cjk-sans # or noto-fonts-cjk = full CJK coverage
      noto-fonts-cjk-serif
      font-awesome # if you also have icon □ problems
      # Optional but often helps:
      liberation_ttf
      dejavu_fonts
    ];

    # This is the most important part — it sets good fallback order
    fontconfig.defaultFonts = {
      sansSerif = ["Noto Sans" "Noto Sans CJK JP" "DejaVu Sans"];
      serif = ["Noto Serif" "Noto Serif CJK JP" "DejaVu Serif"];
      monospace = ["JetBrainsMono Nerd Font" "DejaVu Sans Mono"]; # if you use Nerd Fonts
      emoji = ["Noto Color Emoji"];
    };
  };
}
