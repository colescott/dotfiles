.PHONY: install
install:
	cd nixos && find . -type d -exec mkdir -p /etc/nixos/{} \;
	cd nixos && find . -type f -exec ln -f {} /etc/nixos/{} \;
