{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code Light" ];
      };

      /* 
       * This fixes an issue in 20.03 where running unstable channel apps
       * would corrupt the font cache. See #97441
       */
      #disableVersionedFontConfiguration = true;
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
