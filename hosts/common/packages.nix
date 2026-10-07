{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    htop
    lshw
  ];
}
