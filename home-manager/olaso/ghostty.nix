# Ghostty — aster "Observatory" theme, translated from the theme's
# ghostty/config and ghostty/themes/aster-observatory.
{ ... }: {
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "aster-observatory";

      font-family = "IBM Plex Mono";
      font-size = 12;
      adjust-cell-height = "10%";
      window-padding-x = 16;
      window-padding-y = 14;
      window-padding-balance = true;
      window-decoration = false; # Hyprland draws the borders
      background-opacity = 1;
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
    };

    themes.aster-observatory = {
      palette = [
        "0=#1e1c19"
        "1=#c8735a"
        "2=#9fb8a0"
        "3=#d4a24c"
        "4=#7f9cb0"
        "5=#b08aa0"
        "6=#8fb5ad"
        "7=#c9c0ae"
        "8=#6b6456"
        "9=#e08e74"
        "10=#b9d0b9"
        "11=#f0c472"
        "12=#9cb8cb"
        "13=#c9a6ba"
        "14=#abcfc7"
        "15=#e9e2d3"
      ];
      background = "#111113";
      foreground = "#e9e2d3";
      cursor-color = "#d4a24c";
      cursor-text = "#111113";
      selection-background = "#2e2818";
      selection-foreground = "#e9e2d3";
    };
  };
}
