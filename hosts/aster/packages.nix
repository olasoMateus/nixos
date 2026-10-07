{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    # graphics runtime, pairs with ./nvidia.nix
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers

    alvr # opens firewall ports / needs system integration
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "olaso" ];
}
