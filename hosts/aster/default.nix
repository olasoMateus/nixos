{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./nvidia.nix
    ./desktop.nix
    ./packages.nix
  ];

  networking.hostName = "aster";
  networking.networkmanager.enable = true;

  # Allow generic dynamically-linked binaries (e.g. the Claude Code VS Code
  # extension's bundled `claude`) to run instead of hitting the stub loader.
  programs.nix-ld.enable = true;

  home-manager.users.olaso = {
    imports = [
      ../../home-manager/olaso/base.nix
      ../../home-manager/olaso/desktop.nix
    ];
    home.stateVersion = "25.11";
  };

  services.tailscale.enable = true;

  # The release this machine was installed at. Never copy it to another host.
  system.stateVersion = "25.05";
}
