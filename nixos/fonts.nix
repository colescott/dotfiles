{ pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code Light" ];
      };
    };
    fonts = with pkgs; [
      corefonts
      
      fira
      fira-code
      fira-code-symbols
      fira-mono

      nerdfonts
      emojione
    ];
  };
}
