
# themes/observatory/wofi/style.css.
{ ... }: {
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      prompt = "› launch";
      width = 520;
      height = 260;
      location = "top";
      yoffset = 160;
      insensitive = true;
      allow_images = false;
      no_actions = true;
      hide_scroll = true;
      term = "ghostty";
    };

    style = builtins.readFile ../../themes/observatory/wofi/style.css;
  };
}
