{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "polaris";


  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

  # aster's key
  users.users.olaso.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5pyXMdIGdTF8XXKRtkMEAxn8PRjftpSfGJO9PobYq0 olaso@aster"
  ];

  home-manager.users.olaso = {
    imports = [
      ../../home-manager/olaso/base.nix
    ];
    home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05";
}
