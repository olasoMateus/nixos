{ pkgs, ... }:
let
  sddmObservatory = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-theme-aster-observatory";
    version = "1.0";
    src = ../../themes/observatory/sddm/aster-observatory;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/aster-observatory
      cp -r . $out/share/sddm/themes/aster-observatory
    '';
  };
in
{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "aster-observatory";
  };
  environment.systemPackages = [ sddmObservatory ];

  fonts.packages = [ pkgs.ibm-plex ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.xserver.xkb = {
    layout  = "us";
    variant = "intl";
  };
}
