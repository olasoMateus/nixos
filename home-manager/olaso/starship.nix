# Starship prompt. Lives in base.nix's imports so it reaches every host —
# the hostname segment is what tells an SSH session on polaris apart.
{ ... }:
let
  # No repo-wide theme switch exists yet; every other file points straight at
  # themes/observatory. The other entries are here for when one does.
  theme = "observatory";

  prompt = {
    observatory   = { glyph = "›";  accent = "#d4a24c"; dir = "#8fb5ad"; error = "#c8735a"; };
    # nebula        = { glyph = "✦";  accent = "#c4a7ff"; dir = "#8fe0f0"; error = "#ff8fa3"; };
    # constellation = { glyph = "◆";  accent = "#7fd4ff"; dir = "#a8e2ff"; error = "#ff8a8a"; };
    # backrooms     = { glyph = "L0"; accent = "#f2e08c"; dir = "#8fb5a0"; error = "#d4543f"; };
  }.${theme};
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      palette = "aster";
      palettes.aster = { inherit (prompt) accent dir error; };

      format = "[${prompt.glyph} ](bold accent)$hostname$directory$character";
      hostname = { ssh_only = false; format = "[$hostname](bold accent) "; };
      directory = {
        format = "[$path]($style) ";
        style = "dir";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      character = {
        success_symbol = "[❯](accent)";
        error_symbol = "[❯](error)";
      };
    };
  };
}
