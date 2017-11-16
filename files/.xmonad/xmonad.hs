import           Graphics.X11.ExtraTypes.XF86
import           System.IO
import           XMonad
import           XMonad.Actions.Volume
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Util.EZConfig         (additionalKeys)
import           XMonad.Util.Run              (spawnPipe)
import           XMonad.Util.SpawnOnce

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig
        { startupHook = startup
        , terminal = "konsole"
        , focusedBorderColor = "#586e75"
        , normalBorderColor = "#073642"
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#859900" "" . wrap "[" "]"
            , ppHidden = xmobarColor "#657b83" "" . pad
            , ppUrgent = xmobarColor "#b58900" ""
            , ppTitle = xmobarColor "#859900" "" . shorten 25
            , ppWsSep = ""
            }
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
        , workspaces = ["1", "2:web", "3:kiwi", "4", "5:slack", "6", "7:enpass", "8", "9:vm"]
        , manageHook = manageDocks <+> composeAll
          [ className =? "chrome-kiwi"    --> doShift "3:kiwi"
          , className =? "Google-chrome"  --> doShift "2:web"
          , className =? "Slack"          --> doShift "5:slack"
          , className =? "Enpass-Desktop" --> doShift "7:enpass"
          , className =? "VirtualBox"     --> doShift "9:vm"
          , className =? "stalonetray"    --> doIgnore
        ]
        } `additionalKeys`
        [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s ~/Screenshots/%b%d::%H%M%S.png")
        , ((0, xK_Print), spawn "scrot ~/Screenshots/%b%d.%H:%M:%S.png")
        , ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((0, xF86XK_AudioLowerVolume   ), lowerVolume 2 >> return ())
        , ((0, xF86XK_AudioRaiseVolume   ), raiseVolume 2 >> return ())
        , ((0, xF86XK_AudioMute          ), toggleMute >> return ())
        , ((0, xF86XK_MonBrightnessUp    ), spawn "xbacklight -inc 10")
        , ((0, xF86XK_MonBrightnessDown  ), spawn "xbacklight -dec 10")
        ]

startup = do
    spawn "feh --bg-scale ~/wallpaper-stripes.png"
    spawn "xscreensaver -nosplash"
    spawn "stalonetray"
    spawn "Enpass"
    spawn "slack"
