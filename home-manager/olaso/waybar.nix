{ pkgs, ... }:
let
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  label = text: "<span color='#9a917f'>${text}</span>";
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 0;

      modules-left = [ "custom/host" "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" "custom/date" ];
      modules-right = [
        "cpu"
        "memory"
        "network"
        "pulseaudio"
        "battery"
        "custom/uptime"
        "tray"
        "custom/notification"
      ];

      "custom/host" = {
        exec = "echo ASTER";
        interval = "once";
        tooltip = false;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "●";
          default = "◐";
          empty = "○";
          urgent = "◉";
        };
        all-outputs = true;
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      "hyprland/window" = {
        format = "{class} · {title}";
        max-length = 60;
        separate-outputs = true;
      };

      clock = {
        format = "{:%H:%M:%S}";
        interval = 1;
        tooltip-format = "<tt>{calendar}</tt>";
      };

      "custom/date" = {
        exec = ''m=$(date +%-m); r=$(echo I II III IV V VI VII VIII IX X XI XII | cut -d' ' -f$m); echo "$(date +%d) · $r · $(date +%Y)"'';
        interval = 60;
        tooltip = false;
      };

      cpu = {
        format = "${label "CPU"} {usage}%";
        interval = 2;
      };

      memory = {
        format = "${label "MEM"} {used:0.1f}G";
        interval = 5;
      };

      network = {
        format-ethernet = "${label "NET"} ↓{bandwidthDownBytes}";
        format-wifi = "${label "NET"} ↓{bandwidthDownBytes}";
        format-disconnected = "${label "NET"} off";
        tooltip-format = "{ifname} · {ipaddr}";
        interval = 2;
      };

      pulseaudio = {
        format = "${label "VOL"} {volume}%";
        format-muted = "${label "VOL"} —";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        scroll-step = 5;
      };

      # Hidden at 100%, shown below it. Waybar hides a module whose format is
      # empty, and picks format-<state> over format, where a state applies
      # when capacity <= its value. At 100 no state matches, so the empty
      # `format` wins. No format-<status> may be set: those outrank states.
      battery = {
        states = { below = 99; warning = 30; critical = 15; };
        format = "";
        format-below = "${label "BAT"} {capacity}%";
        format-warning = "${label "BAT"} {capacity}%";
        format-critical = "${label "BAT"} {capacity}%";
        format-charging-below = "${label "BAT"} ↑{capacity}%";
        format-charging-warning = "${label "BAT"} ↑{capacity}%";
        format-charging-critical = "${label "BAT"} ↑{capacity}%";
        tooltip-format = "{timeTo}";
        interval = 30;
      };

      "custom/uptime" = {
        exec = ''awk '{d=int($1/86400); h=int(($1%86400)/3600); printf "%dd %02dh", d, h}' /proc/uptime'';
        format = "${label "UP"} {}";
        interval = 60;
        tooltip = false;
      };

      tray = {
        icon-size = 14;
        spacing = 10;
      };

      "custom/notification" = {
        exec = "${swaync-client} -swb";
        return-type = "json";
        format = "{icon} {}";
        format-icons = {
          none = label "SIG";
          notification = "<span color='#d4a24c'>SIG</span>";
          dnd-none = "<span color='#4a4438'>DND</span>";
          dnd-notification = "<span color='#c8735a'>DND</span>";
          inhibited-none = label "SIG";
          inhibited-notification = "<span color='#d4a24c'>SIG</span>";
          dnd-inhibited-none = "<span color='#4a4438'>DND</span>";
          dnd-inhibited-notification = "<span color='#c8735a'>DND</span>";
        };
        on-click = "${swaync-client} -t -sw";
        on-click-right = "${swaync-client} -d -sw";
        escape = true;
        tooltip = false;
      };
    };

    style = builtins.readFile ../../themes/observatory/waybar/style.css;
  };
}
