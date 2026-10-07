# Shared by every host. Anything in here must work on a headless server too —
# GUI things belong in ./desktop.nix.
#
# Note: this file is evaluated by two different home-manager releases (25.11 on
# aster, 26.05 on polaris), so stick to options that exist in both.
{ ... }: {
  imports = [
    ./packages.nix
    ./git.nix
    ./starship.nix
  ];

  # For starship
  programs.bash.enable = true;

  home.username = "olaso";
  home.homeDirectory = "/home/olaso";
}
