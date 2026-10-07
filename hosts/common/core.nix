{ ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users          = [ "root" "olaso" ];

  nix.gc.automatic = true;
  nix.gc.dates     = "weekly";
  nix.gc.options   = "--delete-older-than 10d";

  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
