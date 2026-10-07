# Layered on top of ./base.nix by graphical hosts only.
{ pkgs, config, ... }: {
  imports = [ ./waybar.nix ./wofi.nix ./ghostty.nix ./yazi.nix ];

  # For when obs is needed
  # programs.obs-studio = {
  #   enable = true;

  #   # optional Nvidia hardware acceleration
  #   package = (
  #     pkgs.obs-studio.override {
  #       cudaSupport = true;
  #     }
  #   );

  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-vaapi #optional AMD hardware acceleration
  #     obs-gstreamer
  #     obs-vkcapture
  #   ];
  # };

  home.packages = with pkgs; [

    # Observatory theme: waybar, wofi, swaync, hyprlock and ghostty are all
    # set in IBM Plex Mono. SDDM gets it separately, in hosts/aster/desktop.nix.
    ibm-plex
    pavucontrol # click on the bar's volume readout
    brightnessctl # hypridle's dim step

    # media
    vlc
    mpv
    ffmpeg-full # large closure; kept off headless hosts on purpose

    # apps
    legcord
    vscode
    postman
    sidequest
    prismlauncher
    qbittorrent
  ];

  # Builds ~/.nix-profile/share/fonts into a fontconfig dir. home.packages
  # alone does not make fonts visible to GTK.
  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
  };

  services.hyprpolkitagent.enable = true;

  # Swaync for notifications, Observatory theme
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../../themes/observatory/swaync/config.json);
    style = builtins.readFile ../../themes/observatory/swaync/style.css;
  };

  services.hyprpaper = {
    enable = true;
    settings.splash = false;
    settings.wallpaper = [{
      monitor = "*";
      path = "${../../themes/observatory/wallpaper/aster-observatory.png}";
      fit_mode = "cover";
    }];
  };

  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ../../themes/observatory/hyprlock/hyprlock.conf;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # one hyprlock at a time
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        { timeout = 150; on-timeout = "brightnessctl -s set 30%"; on-resume = "brightnessctl -r"; }
        { timeout = 300; on-timeout = "loginctl lock-session"; }
        { timeout = 330; on-timeout = "hyprctl dispatch dpms off"; on-resume = "hyprctl dispatch dpms on"; }
      ];
    };
  };

  programs.hyprshot = {
    enable = true;
    saveLocation = "${config.home.homeDirectory}/Pictures";
  };

  services.cliphist.enable = true; # clipboard history, $mod+SHIFT+V

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "hyprlang";

    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";

      # Deliberately NOT setting AQ_DRM_DEVICES. Aquamarine enumerates both
      # GPUs on its own (card0 = NVIDIA 01:00.0, card1 = Intel 00:02.0, both
      # KMS-capable) and picks the one with connected outputs — the displays
      # are all on the Intel.
      #
      # Do not "fix" this by adding by-path entries: AQ_DRM_DEVICES is
      # COLON-separated and by-path names themselves contain colons
      # (pci-0000:00:02.0-card), so the value gets split into garbage
      # fragments, no GPU is found, and Hyprland aborts in CBackend::create()
      # before the logger exists. If it ever needs to be set, use /dev/dri/cardN.
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
        "XDG_SESSION_TYPE,wayland"
      ];

      monitor = [
      "DP-3,1920x1080@144,0x0,1"
      "eDP-1,1920x1080@144,-1920x0,1"
      ];

      input = {
        # US-International with dead keys: ' " ` ^ ~ compose accents on the
        # next letter (' + a = á, ~ + a = ã, ' + c = ç). Press space after one
        # to get the literal character.
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 1;
        layout = "dwindle";
        "col.active_border" = "rgba(d4a24cff)";
        "col.inactive_border" = "rgba(2a2620ff)";
        "col.nogroup_border_active" = "rgba(e9e2d3ff)";
        "col.nogroup_border" = "rgba(2a2620ff)";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow.enabled = false;
        blur.enabled = false;
      };

      group = {
        "col.border_active" = "rgba(d4a24cff)";
        "col.border_inactive" = "rgba(2a2620ff)";
        "col.border_locked_active" = "rgba(c8735aff)";
        "col.border_locked_inactive" = "rgba(2a2620ff)";
        groupbar = {
          font_family = "IBM Plex Mono";
          font_size = 11;
          height = 18;
          text_color = "rgba(e9e2d3ff)";
          "col.active" = "rgba(1e1a12ff)";
          "col.inactive" = "rgba(111113ff)";
        };
      };

      misc.background_color = "rgba(0a0a0bff)";

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive,"
        "$mod, V, togglefloating,"
        "$mod, P, exec, code"
        "$mod, F, fullscreen,"
        "$mod, Y, exec, ghostty -e yazi"

        "$mod, SPACE, exec, pkill wofi || wofi"
        "$mod, R, exec, pkill wofi || wofi"
        "$mod, L, exec, loginctl lock-session"
        "$mod SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # Print
        "CTRL SHIFT, S, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m window"


        # Leaves Hyprland and drops you back at SDDM. Without a binding like
        # this the only way out is a TTY.
        "$mod SHIFT, M, exit,"

        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"
      ]
      ++ (
        # Workspaces 1-9: $mod+N focuses, $mod+SHIFT+N moves the window there.
        builtins.concatLists (builtins.genList
          (i:
            let ws = builtins.toString (i + 1);
            in [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ])
          9)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
