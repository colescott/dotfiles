{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zimfw;
  pkg = (cfg: cfg.package.override {
      customZimrc = ''
        zmodules=(${concatStringsSep "\\\n " cfg.modules})

        ${optionalString (stringLength(cfg.theme) > 0)
          "zprompt_theme='${cfg.theme}'"
        }

        ztermtitle='%n@%m:%~'

        ${optionalString (stringLength(cfg.inputMode) > 0)
          "zinput_mode='${cfg.inputMode}'"
        }

        zhighlighters=(main brackets cursor)

        ${optionalString (stringLength(cfg.extraConfig) > 0)
          cfg.extraConfig
        }
    '';
    });
in
  {
    options = {
      programs.zsh.zimfw = {
        enable = mkOption {
          default = false;
          description = ''
            Enable zimfw.
          '';
        };

        package = mkOption {
          default = pkgs.callPackage ./zimfw.nix {};
          defaultText = "./zimfw.nix";
          description = ''
            Package to install for `zimfw` usage.
          '';

          type = types.package;
        };

        modules = mkOption {
          default = [
            "directory"
            "environment"
            "git"
            "git-info"
            "history"
            "input"
            "utility"
            "custom"
            "syntax-highlighting"
            "history-substring-search"
            "prompt"
            "completion"
          ];
          type = types.listOf(types.str);
          description = ''
            List of zimfw modules to enable
          '';
        };

        theme = mkOption {
          default = "steeef";
          type = types.str;
          description = ''
            Name of the theme to be used by zimfw.
          '';
        };

        inputMode = mkOption {
          default = "emacs";
          type = types.str;
          description = ''
            Input mode of zimfw (emacs or vi)
          '';
        };

        extraConfig = mkOption {
          default = "";
          type = types.str;
          description = ''
            Extra config to append to zimrc
          '';
        };

        custom = mkOption {
          default = "";
          type = types.str;
          description = ''
            Path to a custom zimrc file to override config for zimfw.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [
        (pkg cfg)
      ];

      programs.zsh.promptInit = ''
      # Init zimfw
      source ${pkg cfg}/share/zimfw/.zim/init.zsh
      '';
    };
  }
