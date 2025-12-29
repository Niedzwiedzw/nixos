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
      monospace = ["Maple Mono NF" "Maple Mono"];
      sansSerif = ["Maple Mono NF" "Maple Mono"];
      serif = ["Maple Mono NF" "Maple Mono"];
      emoji = ["Maple Mono NF" "Noto Color Emoji"];
    };
  };
}
