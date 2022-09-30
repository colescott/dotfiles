{ config, pkgs, ... }:

{
  services.udev.packages = with pkgs; [ yubikey-personalization openocd ];
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

# Teensy rules for the Ergodox EZ Original / Shine / Glow
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Create "/dev" entries for Digilent device's with read and write
# permission granted to all users.
ATTR{idVendor}=="1443", MODE:="666"
ACTION=="add", ATTR{idVendor}=="0403", MODE:="666"

SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="04d8", ATTR{idProduct}=="900a", MODE="0666", GROUP="plugdev"

# Rules for Keysight
SUBSYSTEM=="usb", ATTR{idVendor}=="2a8d", ATTR{idProduct}=="0396", MODE="0666", GROUP="plugdev"
  '';
}
