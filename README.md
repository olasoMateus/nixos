# nixos

Multi-host NixOS flake — `aster` (laptop, unstable) and `polaris` (server,
stable). 

## Credits

The Hyprland desktop's look is ported from [Anik200/dotfiles][upstream], a
HyDE-style rice:

- [`home-manager/olaso/waybar.nix`](home-manager/olaso/waybar.nix) — from that
  repo's `.config/waybar/{config.jsonc,style.css}`
- [`home-manager/olaso/wofi.nix`](home-manager/olaso/wofi.nix) — from its
  `.config/rofi/style.rasi`, itself an [adi1090x][adi] rofi theme, reworked for
  wofi

Both are ports of the *look*, not copies of the config: the upstream's helper
scripts, `ags` panel and hardcoded home paths have no equivalent here. Each
module's header comment records what was kept and what was dropped.

[upstream]: https://github.com/Anik200/dotfiles
[adi]: https://github.com/adi1090x/rofi
