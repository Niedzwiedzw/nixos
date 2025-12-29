{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted

      noto-fonts
      noto-fonts-color-emoji
      font-awesome
    ];

    fontconfig.defaultFonts = {
      monospace = ["Maple Mono"];
      sansSerif = ["Maple Mono"];
      serif = ["Maple Mono"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
