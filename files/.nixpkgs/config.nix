{
  allowUnfree = true;

  packageOverrides = pkgs_: with pkgs_; {

    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        # Zsh stuff
        fortune
        cowsay
        lolcat

        # Basic apps
        discord
        google-chrome
        vscode
        slack
        spotify

        # Games
        steam

        # Utils
        file
        nox
        openssl
      ];
    };
  };
}
