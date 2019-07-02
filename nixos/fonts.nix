{ pkgs, ... }:

{
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code Light" ];
      };
    };
    fonts = with pkgs; [
      powerline-fonts
      source-code-pro
      fira
      fira-code
      fira-code-symbols
      fira-mono
      emojione
    ];
  };
}
