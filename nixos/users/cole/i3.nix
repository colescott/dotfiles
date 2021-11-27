{ pkgs, unstable, ... }:

''
### Variables
#
set $mod Mod4
set $left h
set $down j
set $up k
set $right l
set $term ${pkgs.kitty}/bin/kitty
set $menu ${pkgs.rofi}/bin/rofi -show run
set $pass ${pkgs.rofi-pass}/bin/rofi-pass

### Output configuration
#
# Default wallpaper
#output * bg ~/wallpaper.png fill
#output * pos 1920 0 res 1920x1080 scale 1
#output eDP-1 pos 0 0 res 1920x1080 scale 1


### Auto sleep
#
#exec ${pkgs.swayidle}/bin/swayidle -w \
#          timeout 300 '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
#          timeout 600 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
#               resume '${pkgs.sway}/bin/swaymsg "output * dpms on"' \
#         before-sleep '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
#                 lock '${pkgs.swaylock}/bin/swaylock -f -c 000000'
#bindsym $mod+Shift+z exec loginctl lock-session

### Input configuration
#
#input "1:1:AT_Translated_Set_2_keyboard" {
#    xkb_layout us
#    xkb_options ctrl:nocaps
#}
#
#input "2:7:SynPS/2_Synaptics_TouchPad" {
#    dwt enabled
#    tap enabled
#    middle_emulation enabled
#}

exec setxkbmap -option ctrl:nocaps

### Key bindings
#
# Basics:
#
    # start a terminal
    bindsym $mod+Return exec $term
    bindsym $mod+Shift+Return exec $term

    # kill focused window
    bindsym $mod+Shift+c kill

    # start your launcher
    bindsym $mod+d exec $menu
    bindsym $mod+p exec $menu
    bindsym $mod+Shift+p exec $pass

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    floating_modifier $mod

    # reload the configuration file
    bindsym $mod+Shift+q reload

    # exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec swaynag -t warning -m 'Are you sure?' -b 'Yes' 'swaymsg exit'

    # volume controls (special keys on keyboard)
    bindsym XF86AudioRaiseVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set 'Master' 5%+
    bindsym XF86AudioLowerVolume exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set 'Master' 5%-
    bindsym XF86AudioMute exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set 'Master' toggle
    bindsym XF86AudioMicMute exec --no-startup-id ${pkgs.alsaUtils}/bin/amixer set 'Capture' toggle

    bindsym XF86MonBrightnessUp exec --no-startup-id ${pkgs.light}/bin/light -A 10
    bindsym XF86MonBrightnessDown exec --no-startup-id ${pkgs.light}/bin/light -U 10

    bindsym --release Print exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)" ~/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')
    bindsym --release Shift+Print exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
#
# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # _move_ the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspaces:
#
    # switch to workspace
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10
    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show


#
# Default workspace location
#
assign [class="Firefox"] 2
assign [class="Chromium"] 2
assign [class="Slack"] 5
assign [class="discord"] 6
assign [class="spotify"] 7

for_window [title="zoom_linux_float_message_reminder"] floating enable

#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

#
# Borders
#
default_border none

#
# Status Bar:
#
#bar {
#    swaybar_command ${pkgs.waybar.override { pulseSupport = true; } }/bin/waybar
#    position top
#}

# Fix bug with DPI breaking after external monitor is disconnected
# See swaywm/wlroots#1119
exec xrdb -load ~/.Xresources
''
