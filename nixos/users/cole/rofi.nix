{ pkgs, ... }:

{
  enable = true;
  theme = "solarized";
  terminal = "${pkgs.kitty}/bin/kitty";
}
