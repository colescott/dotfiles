{ config, ... }:

{
  services.udev.extraRules = ''
# This fixes the issue where Steam  weren't detecting the controller. My
# theory is that the games needed (wanted) access to the raw USB device rather
# than any interface (/dev/js0)
#
# Device info:
# ID 045e:028e Microsoft Corp. Xbox360 Controller
# fix permissions on /dev/usb/???/???
SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", GROUP="plugdev", MODE="0664"
# fix permissions on /dev/input/event*
SUBSYSTEMS=="input" ATTRS{name}=="Microsoft X-Box 360 pad", GROUP="plugdev", MODE="0640"
  '';
}
