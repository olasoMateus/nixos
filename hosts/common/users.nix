{ ... }: {
  users.users.olaso = {
    isNormalUser = true;
    description  = "Mateus Olaso";
    extraGroups  = [ "networkmanager" "wheel" "plugdev" "video" "render" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "olaso" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
