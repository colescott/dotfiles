.PHONY: install
install:
	cd files && find . -type d -exec mkdir -p ~/{} \;
	cd files && find . -type f -exec ln {} ~/{} \;
