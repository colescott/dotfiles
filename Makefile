.PHONY: install-nixos
install-nixos:
	cd nixos && find . -type d -exec mkdir -p /etc/nixos/{} \;
	cd nixos && find . -type f -exec ln {} /etc/nixos/{} \;

.PHONY: install-home
install-home:
	cd files && find . -type d -exec mkdir -p ~/{} \;
	cd files && find . -type f -exec ln {} ~/{} \;

.PHONY: init-repo
init-repo:
	git update-index --assume-unchanged nixos/machine-configuration.nix
