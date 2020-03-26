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
      fira
      fira-code
      fira-code-symbols
      fira-mono

      nerdfonts
      emojione
    ];
  };
}
