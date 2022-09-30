{ pkgs, config, ... }:

{
  users.extraGroups.docker = {
    name = "docker";
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker-edge;
}
