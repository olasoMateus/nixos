# yazi — aster "Observatory" flavor. The flavor folder (flavor.toml plus
# tmtheme.xml for code previews) is kept verbatim in
# themes/observatory/yazi/. Its icons are Nerd Font glyphs, which Ghostty
# draws from its built-in symbol font.
{ ... }: {
  programs.yazi = {
    enable = true;

    flavors.aster-observatory = ../../themes/observatory/yazi/aster-observatory.yazi;

    # Same flavor whether yazi detects a dark or a light terminal
    theme.flavor = {
      dark = "aster-observatory";
      light = "aster-observatory";
    };
  };
}
