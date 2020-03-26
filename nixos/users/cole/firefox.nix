{ pkgs, ... }:

{
  enable = true;
  #enableAdobeFlash = true;
  package = pkgs.firefox-beta-bin-unwrapped;
}
