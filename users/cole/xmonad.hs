{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}

import           Control.Monad
import           Data.String
import           Graphics.X11.ExtraTypes.XF86
import           System.IO

import           XMonad                       ((-->), (.|.), (<+>), (=?), (|||))
import qualified XMonad                       as X

import qualified XMonad.Actions.CopyWindow    as CopyW
import           XMonad.Actions.Volume

import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral

import qualified XMonad.Hooks.SetWMName       as X
import qualified XMonad.Hooks.DynamicBars     as Bars
import qualified XMonad.Hooks.DynamicLog      as DLog
import qualified XMonad.Hooks.ManageDocks     as Docks
import qualified XMonad.Hooks.ManageHelpers   as ManageHelpers

import qualified XMonad.StackSet as W

import           XMonad.Util.EZConfig         (additionalKeys)
import qualified XMonad.Util.Run              as Run
import qualified XMonad.Util.SpawnOnce        as Run

{----------------
-  Colors, etc. -
----------------}

newtype Color = Color { unColor :: String } deriving (IsString)

data ColorPair = ColorPair {
  foreground :: Color,
  background :: Color
}

xmobarColor ColorPair{..} = DLog.xmobarColor (unColor foreground) (unColor background)

data ColorPreferences = ColorPreferences {
  normal        :: ColorPair,
  current       :: ColorPair,
  visible       :: ColorPair,
  urgent        :: ColorPair,
  special1      :: ColorPair,
  special2      :: ColorPair,
  separator     :: ColorPair,
  copy          :: Color,
  focusedBorder :: Color,
  normalBorder  :: Color
}

data Preferences = Preferences {
  colorPreferences :: ColorPreferences,
  terminal         :: String,
  modMask          :: X.KeyMask
}

main = runXmonad Preferences {
  colorPreferences = ColorPreferences {
    normal = ColorPair "#698787" "#042C4D",
    current = ColorPair "#698787" "#888888",
    visible = ColorPair "#698787" "#444444",
    special1 = ColorPair "#aaffaa" "#042C4D",
    special2 = ColorPair "#ffaaff" "#042C4D",
    separator = ColorPair "#698787" "#042C4D",
    copy = "#ff0000",
    focusedBorder = "#586e75",
    normalBorder = "#073642"
  },
  terminal = "kitty",
  modMask = X.mod1Mask
}

runXmonad prefs@Preferences{..} =
    X.xmonad $ X.def
      { X.startupHook = startup prefs
        , X.terminal = terminal
        , X.focusedBorderColor = unColor $ focusedBorder colorPreferences
        , X.normalBorderColor = unColor $ normalBorder colorPreferences
        , X.focusFollowsMouse = False
        , X.clickJustFocuses = False
        , X.logHook =
            CopyW.wsContainingCopies
                >>= \copies ->
                  Bars.multiPP (logPPActive colorPreferences copies)
                                 (logPP colorPreferences copies)
        , X.layoutHook = Docks.avoidStruts $ noBorders $
            named "T" (ResizableTall 1 (2/100) (1/2) []) |||
            named "F" X.Full
        , X.handleEventHook =
                Docks.docksEventHook
            <+> Bars.dynStatusBarEventHook barCreator barDestroyer
        , X.workspaces = ["1", "2:web", "3", "4", "5:social", "6", "7", "8:cmus", "9"]
        , X.manageHook = X.composeAll
          [ ManageHelpers.isFullscreen            --> ManageHelpers.doFullFloat
          , X.className =? "Google-chrome"        --> X.doShift "2:web"
          , X.className =? "Franz"                --> X.doShift "5:social"
          , X.stringProperty "WM_NAME" =? "cmus"  --> X.doShift "8:cmus"
          , X.className =? "stalonetray"          --> X.doIgnore
          , Docks.manageDocks
        ]
        } `additionalKeys`
        [ ((X.controlMask, X.xK_Print), X.spawn "sleep 0.2; scrot -s ~/Screenshots/%b%d::%H%M%S.png")
        , ((0, X.xK_Print), X.spawn "scrot ~/Screenshots/%b%d.%H:%M:%S.png")
        , ((modMask .|. X.shiftMask, X.xK_z), X.spawn "light-locker-command --lock")
        , ((0, xF86XK_AudioLowerVolume   ), Control.Monad.void (lowerVolume 2))
        , ((0, xF86XK_AudioRaiseVolume   ), Control.Monad.void (raiseVolume 2))
        , ((0, xF86XK_AudioMute          ), Control.Monad.void toggleMute)
        , ((0, xF86XK_AudioPlay          ), X.spawn "cmus-remote --pause")
        , ((0, xF86XK_AudioNext          ), X.spawn "cmus-remote --next")
        , ((0, xF86XK_AudioPrev          ), X.spawn "cmus-remote --prev")
        , ((0, xF86XK_MonBrightnessUp    ), X.spawn "xbacklight -inc 10")
        , ((0, xF86XK_MonBrightnessDown  ), X.spawn "xbacklight -dec 10")
        ]

startup Preferences{..} = do
    Bars.dynStatusBarStartup barCreator barDestroyer
    X.spawn "feh --bg-scale ~/wallpaper.png"
    X.spawn "franz"
    Run.spawnOnce (terminal ++ " cmus")

{---------------
-  Status bar  -
---------------}

logPP :: ColorPreferences -> [X.WorkspaceId] -> DLog.PP
logPP prefs@ColorPreferences{..} copies = DLog.def
  { DLog.ppCurrent = xmobarColor current . DLog.pad
  , DLog.ppVisible = xmobarColor visible . DLog.pad
  , DLog.ppHidden  = checkCopies normal
  , DLog.ppUrgent  = xmobarColor urgent . DLog.wrap ">" "<" . DLog.xmobarStrip
  , DLog.ppTitle   = xmobarColor special1 . DLog.shorten 25
  , DLog.ppLayout  = xmobarColor special2
  , DLog.ppOrder = \(ws:_:t:_) -> [ws, t] -- Remove layout from title
  , DLog.ppSep     = DLog.pad $ xmobarColor separator "|"
  }
  where
      checkCopies usual ws =
        if ws `elem` copies then
            xmobarColor (ColorPair copy (background usual)) ws
        else
            xmobarColor usual ws



logPPActive :: ColorPreferences -> [X.WorkspaceId] -> DLog.PP
logPPActive prefs@ColorPreferences{..} copies = (logPP prefs copies)
  { DLog.ppCurrent = xmobarColor current . DLog.pad
  }

barCreator :: Bars.DynamicStatusBar
barCreator (X.S sid) = do
  X.spawn stalonetrayCmd
  Run.spawnPipe $ "xmobar --screen=" ++ show sid
    where
      stalonetrayCmd = "stalonetray --icon-size=" ++ show iconSize ++ " --geometry=" ++ geometry ++ " --max-geometry=" ++ maxGeometry
      geometry = show numIcons ++ "x1+" ++ show (screenWidth * (sid + 1) - maxWidth) ++ "+0"
      maxGeometry = show numIcons ++ "x1+" ++ show (screenWidth * (sid + 1)) ++ "+0"
      numIcons = 8
      iconSize = 24
      screenWidth = 1920
      maxWidth = numIcons * iconSize

barDestroyer :: Bars.DynamicStatusBarCleanup
barDestroyer = return ()
