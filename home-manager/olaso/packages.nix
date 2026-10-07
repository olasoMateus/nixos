{ pkgs, ... }: {
  home.packages = with pkgs; [
    # misc
    cowsay
    file
    which
    tree

    # nix
    nix-output-monitor

    # monitoring
    btop

    # system tools
    ethtool
    pciutils
    usbutils

    opencode
    claude-code
    python3
  ];
}
