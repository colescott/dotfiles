import           Graphics.X11.ExtraTypes.XF86
import           System.IO

import XMonad ((-->), (.|.), (=?), (<+>), (|||))
import qualified XMonad as X

import           XMonad.Actions.Volume
import qualified XMonad.Actions.CopyWindow as CopyW

import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral
import XMonad.Layout.Named
import XMonad.Layout.ResizableTile

import qualified XMonad.Hooks.DynamicLog as DLog
import qualified XMonad.Hooks.DynamicBars as Bars
import qualified XMonad.Hooks.ManageDocks as Docks
import qualified XMonad.Hooks.ManageHelpers as ManageHelpers

import           XMonad.Util.EZConfig         (additionalKeys)
import qualified XMonad.Util.Run as Run

{----------------
-  Colors, etc. -
----------------}

myNormalFG    = "#698787"
myNormalBG    = "#042C4D"
myCurrentFG   = myNormalFG
myCurrentBG   = "#888888"
myVisibleFG   = myNormalFG
myVisibleBG   = "#444444"
myUrgentFG    = myNormalFG
myUrgentBG    = "#ff6600"
mySpecial1FG  = "#aaffaa"
mySpecial1BG  = myNormalBG
mySpecial2FG  = "#ffaaff"
mySpecial2BG  = myNormalBG
mySeparatorFG = "#000066"
mySeparatorBG = "#000033"
myCopyFG      = "#ff0000"

myTerminal        = "konsole"
myModMask         = X.mod1Mask

main =
    X.xmonad $ X.defaultConfig
        { X.startupHook = startup
        , X.terminal = myTerminal
        , X.focusedBorderColor = "#586e75"
        , X.normalBorderColor = "#073642"
        , X.focusFollowsMouse = False
        , X.logHook =
            CopyW.wsContainingCopies
                >>= \copies ->
                    Bars.multiPP (myLogPPActive copies)
                                 (myLogPP copies)
        , X.layoutHook = spacing 4 $ Docks.avoidStruts $ noBorders $
            named "T" (ResizableTall 1 (2/100) (1/2) []) |||
            named "F" (X.Full)
        , X.handleEventHook =
                Docks.docksEventHook
            <+> Bars.dynStatusBarEventHook barCreator barDestroyer
        , X.workspaces = ["1", "2:web", "3:kiwi", "4", "5:social", "6", "7", "8", "9"]
        , X.manageHook = X.composeAll
          [ isAndroid --> ManageHelpers.doCenterFloat
          , ManageHelpers.isFullscreen --> ManageHelpers.doFullFloat
          , X.className =? "chrome-kiwi"          --> X.doShift "3:kiwi"
          , X.className =? "Google-chrome"        --> X.doShift "2:web"
          , X.className =? "Franz"                --> X.doShift "5:social"
          , X.stringProperty "WM_NAME" =? "IRSSI" --> X.doShift "5:social"
          , X.className =? "VirtualBox"           --> X.doShift "9:vm"
          , X.className =? "stalonetray"          --> X.doIgnore
          , Docks.manageDocks
        ]
        } `additionalKeys`
        [ ((X.controlMask, X.xK_Print), X.spawn "sleep 0.2; scrot -s ~/Screenshots/%b%d::%H%M%S.png")
        , ((0, X.xK_Print), X.spawn "scrot ~/Screenshots/%b%d.%H:%M:%S.png")
        , ((myModMask .|. X.shiftMask, X.xK_z), X.spawn "xscreensaver-command -lock")
        , ((0, xF86XK_AudioLowerVolume   ), lowerVolume 2 >> return ())
        , ((0, xF86XK_AudioRaiseVolume   ), raiseVolume 2 >> return ())
        , ((0, xF86XK_AudioMute          ), toggleMute >> return ())
        , ((0, xF86XK_MonBrightnessUp    ), X.spawn "xbacklight -inc 10")
        , ((0, xF86XK_MonBrightnessDown  ), X.spawn "xbacklight -dec 10")
        ]

startup = do
    Bars.dynStatusBarStartup barCreator barDestroyer
    X.spawn "feh --bg-scale ~/wallpaper.png"
    X.spawn "compton -f -D 2"
    X.spawn "stalonetray"
    X.spawn "Franz"
    X.spawn "konsole --profile \"IRSSI\""

{---------------
-  Status bar  -
---------------}

myLogPP :: [X.WorkspaceId] -> DLog.PP
myLogPP copies = DLog.defaultPP
  { DLog.ppCurrent = DLog.xmobarColor myCurrentFG myCurrentBG . DLog.pad
  , DLog.ppVisible = DLog.xmobarColor myVisibleFG myVisibleBG . DLog.pad
  , DLog.ppHidden  = checkCopies myNormalFG myNormalBG
  , DLog.ppUrgent  = DLog.xmobarColor myUrgentFG myUrgentBG . DLog.wrap ">" "<" . DLog.xmobarStrip
  , DLog.ppTitle   = DLog.xmobarColor mySpecial1FG mySpecial1BG . DLog.shorten 25
  , DLog.ppLayout  = DLog.xmobarColor mySpecial2FG mySpecial2BG
  , DLog.ppOrder = \(ws:_:t:_) -> [ws, t] -- Remove layout from title
  , DLog.ppSep     = DLog.pad $ DLog.xmobarColor mySeparatorFG mySeparatorBG "|"
  }
  where
      checkCopies usualFG usualBG ws =
        if ws `elem` copies then
            DLog.xmobarColor myCopyFG usualBG ws
        else
            DLog.xmobarColor usualFG usualBG ws

myLogPPActive :: [X.WorkspaceId] -> DLog.PP
myLogPPActive copies = (myLogPP copies)
  { DLog.ppCurrent = DLog.xmobarColor myCurrentBG myCurrentFG . DLog.pad
  }

barCreator :: Bars.DynamicStatusBar
barCreator (X.S sid) = Run.spawnPipe $ "xmobar --screen=" ++ show sid

barDestroyer :: Bars.DynamicStatusBarCleanup
barDestroyer = return ()

-- Stuffs to check things
isAndroid :: X.Query Bool
isAndroid = (X.className =? "emulator64-arm")

