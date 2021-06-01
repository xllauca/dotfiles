-------------------------------------------------------------------------------
--                  __  ____  __                       _                     --
--                  \ \/ /  \/  | ___  _ __   __ _  __| |                    --
--                   \  /| |\/| |/ _ \| '_ \ / _` |/ _` |                    --
--                   /  \| |  | | (_) | | | | (_| | (_| |                    --
--                  /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|                    --
--                                                                           --
-------------------------------------------------------------------------------
--          written by Shotaro Fujimoto (https://github.com/ssh0)
--          modified and repaired by Ogis (https://github.com/Minda1975)
-------------------------------------------------------------------------------
-- Import modules                                                           {{{
-------------------------------------------------------------------------------
--Base
import System.IO (hPutStrLn)
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M
import Control.Monad (liftM2)
import XMonad.Config.Desktop -- myManageHookShift
import Data.Monoid
import Data.Maybe (isJust)
import System.Exit (exitSuccess)
import System.IO                       -- for xmobar
import XMonad
import qualified XMonad.StackSet as W  -- myManageHookShift

--Actions
import XMonad.Actions.CopyWindow
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies, runOrCopy)
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen, swapNextScreen)
import XMonad.Actions.DwmPromote       -- zoom swap dwm style
import XMonad.Actions.DynamicWorkspaces (addWorkspacePrompt, removeEmptyWorkspace)
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect
import XMonad.Actions.Minimize (minimizeWindow)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
import XMonad.Actions.WindowGo (runOrRaise, raiseMaybe)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.ConstrainedResize as Sqr
import qualified XMonad.Actions.FlexibleResize as Flex -- flexible resize

-- Hooks
import XMonad.Hooks.DynamicLog         -- for xmobar
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, defaultPP, wrap, pad, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.EwmhDesktops   -- required for xcomposite in obs to work
import XMonad.Hooks.ManageDocks        -- avoid xmobar area
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat) 
import XMonad.Hooks.Place (placeHook, withGaps, smart)
import XMonad.Hooks.SetWMName

-- Layouts
import XMonad.Layout
import XMonad.Layout.DragPane          -- see only two window
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.IM (withIM, Property(Role))
import XMonad.Layout.LayoutScreens
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
--import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), Toggle(..), (??))
--import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
--import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.NoBorders
import XMonad.Layout.NoBorders         -- In Full mode, border is no use
import XMonad.Layout.OneBig
import XMonad.Layout.PerWorkspace      -- Configure layouts on a per-workspace
import XMonad.Layout.PerWorkspace (onWorkspace) 
import XMonad.Layout.Reflect (reflectVert, reflectHoriz, REFLECTX(..), REFLECTY(..))
import XMonad.Layout.Renamed
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace))
import XMonad.Layout.ResizableTile     -- Resizable Horizontal border
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing           -- this makes smart space around windows
import XMonad.Layout.Spacing (spacing) 
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts     -- Full window at any time
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.ZoomRow (zoomRow, zoomIn, zoomOut, zoomReset, ZoomMessage(ZoomFullToggle))
--import XMonad.Layout.Transparent

import XMonad.Prompt
import XMonad.Prompt.Window            -- pops up a prompt with window names
import XMonad.Prompt (defaultXPConfig, XPConfig(..), XPPosition(Top), Direction1D(..))

-- utilities
import XMonad.Util.EZConfig            -- removeKeys, additionalKeys
import XMonad.Util.Run
import XMonad.Util.Run(spawnPipe)      -- spawnPipe, hPutStrLn
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce

xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) 
               $ ["dev", "www", "feed", "mus", "vid", "vbox", "ops1", "ops2", "misc"]
  where                                                                      
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,                                        
                      let n = i ] 
modm = mod1Mask
-- Arc Color Setting
colorBlue       = "#D8DEE9"
colorGreen      = "#5E81AC"
colorRed        = "#BF616A"
colorGray       = "#EDEDED"
colorWhite      = "#ffffff"
colorNormalbg   = "#2E3440"
colorfg = "#8FBCBB"


-- Border width
borderwidth = 3
myTerminal      = "xfce4-terminal"
myFont  = "xft:SauceCodePro Nerd Font Mono:size=124:antialias=true"
-- Border color
mynormalBorderColor  = "#333333"
--myfocusedBorderColor = "#585858"
myfocusedBorderColor = "#cca8c9"

-- Float window control width
moveWD = borderwidth
resizeWD = 2*borderwidth

--------
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x31,0x2e,0x39) -- lowest inactive bg
                  (0x31,0x2e,0x39) -- highest inactive bg
                  (0x61,0x57,0x72) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0xff,0xff,0xff) -- active fg

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = defaultGSConfig

--
-- Autostart
myStartupHook = do
    spawn "/home/xllauca/.config/dotfiles/scripts/autostart.sh"
    setWMName "LG3D"

--------------------------------------------------------------------------- }}}
-- main                                                                     {{{
-------------------------------------------------------------------------------

main :: IO ()

main = do
    wsbar <- spawnPipe myWsBar
    xmonad $ ewmh def
       { borderWidth        = borderwidth
       , terminal           = myTerminal
       , focusFollowsMouse  = True
       , normalBorderColor  = mynormalBorderColor
       , focusedBorderColor = myfocusedBorderColor
       , startupHook        = myStartupHook
       , manageHook         = myManageHookShift <+>
                              myManageHookFloat <+>
                              manageDocks
       , layoutHook         = avoidStruts $ ( toggleLayouts (noBorders Full)
                                            -- $ onWorkspace "3" simplestFloat
                                            $ myLayout
                                            )
        -- xmobar setting
       , logHook = myLogHook wsbar >> updatePointer (0.5,0.5) (0,0)
       , handleEventHook    = fullscreenEventHook <+> docksEventHook
       , workspaces         = myWorkspaces
       , modMask            = modm
       , mouseBindings      = newMouse
       } `additionalKeysP`    myKeys 	

---KEYBINDINGS
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    -- Windows
        , ("M-S-c", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all the windows on current workspace
        , ("M4-l", spawn "slock")                         -- Kill all the windows on current workspace

    -- Floating windows
        , ("M-<Delete>", withFocused $ windows . W.sink)  -- Push floating window back to tile.
        , ("M-S-<Delete>", sinkAll)                  -- Push ALL floating windows back to tile.

    -- Grid Select
        , (("M-S-o"), spawnSelected'
          [ ("Steam", "steam")
          , ("OBS", "obs")
          , ("Qutebrowser", "qutebrowser")
          , ("Kdenlive", "kdenlive")
		  , ("Audacity", "audacity")
		  , ("Joplin", "joplin-desktop")
		  , ("Deadbeef", "deadbeef")
		  , ("Pavucontrol", "pavucontrol")
		  , ("ARandR", "arandr")
          ])

    --    , ("M-S-g", goToSelected $ mygridConfig myColorizer)
     --   , ("M-S-b", bringSelected $ mygridConfig myColorizer)

    -- Windows navigation
        , ("M-m", windows W.focusMaster)             -- Move focus to the master window
        , ("M-j", windows W.focusDown)               -- Move focus to the next window
        , ("M-k", windows W.focusUp)                 -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster)            -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)              -- Swap the focused window with the next window
        , ("M-S-k", windows W.swapUp)                -- Swap the focused window with the prev window
        , ("M-<Backspace>", promote)                 -- Moves focused window to master, all others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)              -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)                 -- Rotate all the windows in the current stack
        , ("M-S-s", windows copyToAll)  
        , ("M-C-s", killAllOtherCopies) 
        
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Up>", sendMessage (MoveUp 10))             --  Move focused window to up
        , ("M-<Down>", sendMessage (MoveDown 10))         --  Move focused window to down
        , ("M-<Right>", sendMessage (MoveRight 10))       --  Move focused window to right
        , ("M-<Left>", sendMessage (MoveLeft 10))         --  Move focused window to left
        , ("M-S-<Up>", sendMessage (IncreaseUp 10))       --  Increase size of focused window up
        , ("M-S-<Down>", sendMessage (IncreaseDown 10))   --  Increase size of focused window down
        , ("M-S-<Right>", sendMessage (IncreaseRight 10)) --  Increase size of focused window right
        , ("M-S-<Left>", sendMessage (IncreaseLeft 10))   --  Increase size of focused window left
        , ("M-C-<Up>", sendMessage (DecreaseUp 10))       --  Decrease size of focused window up
        , ("M-C-<Down>", sendMessage (DecreaseDown 10))   --  Decrease size of focused window down
        , ("M-C-<Right>", sendMessage (DecreaseRight 10)) --  Decrease size of focused window right
        , ("M-C-<Left>", sendMessage (DecreaseLeft 10))   --  Decrease size of focused window left

    -- Layouts

        , ("M-h", sendMessage Shrink)
        , ("M-l", sendMessage Expand)
        , ("M-C-j", sendMessage MirrorShrink)
        , ("M-C-k", sendMessage MirrorExpand)
        , ("M-S-;", sendMessage zoomReset)
        , ("M-;", sendMessage ZoomFullToggle)

    -- Workspaces
        , ("M-.", nextScreen)                           -- Switch focus to next monitor
        , ("M-,", prevScreen)                           -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next workspace
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to previous workspace

        , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))
        , ("M-t", spawn "telegram-desktop")
		
    --- Dmenu
        , ("M-p", spawn "dmenu_run")
        , ("M-e", spawn "~/.config/dmenu/dmenu_emoji.sh")


    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "deadbeef --play-pause")
        , ("<XF86AudioStop>", spawn "deadbeef --stop")
        , ("<XF86AudioPrev>", spawn "deadbeef --prev")
        , ("<XF86AudioNext>", spawn "deadbeef --next")
        , ("<XF86MonBrightnessUp>", spawn "bright")
        , ("<XF86MonBrightnessDown>", spawn "bright -d")
        , ("<XF86AudioMute>",   spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "qutebrowser")
        , ("<XF86Search>", safeSpawn "qutebrowser" ["https://www.duckduckgo.com/"])
        , ("<XF86Mail>", runOrRaise "geary" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "gcalctool" (resource =? "gcalctool"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "scrotd 0")
        ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

myLayout =  tiled ||| mtiled ||| full ||| threecol ||| grid
	where
    nmaster  = 1     -- Default number of windows in master pane
    delta    = 2/100 -- Percentage of the screen to increment when resizing
    ratio    = 1/2   -- Defaul proportion of the screen taken up by main pane
    rt       = spacing 5 $ ResizableTall nmaster delta ratio []
    tiled    = renamed [Replace "T"] $ smartBorders rt
    mtiled   = renamed [Replace "Bs"] $ smartBorders $ Mirror rt
    full     = renamed [Replace "M"] $ noBorders Full
    threecol = renamed [Replace "3c"] $ ThreeColMid 1 (3/100) (1/2)
    grid     = renamed [Replace "G"] $ GridRatio (3/3)
--------------------------------------------------------------------------- }}}
-- myManageHookShift: some window must created there                        {{{
-------------------------------------------------------------------------------

myManageHookShift = composeAll
            -- if you want to know className, type "$ xprop|grep CLASS" on shell
            [ className =? "Gimp"       --> mydoShift "3"
            ]
             where mydoShift = doF . liftM2 (.) W.greedyView W.shift

--------------------------------------------------------------------------- }}}
-- myManageHookFloat: new window will created in Float mode                 {{{
-------------------------------------------------------------------------------

myManageHookFloat = composeAll
    [ className =? "Gimp"             --> doFloat
    , className =? "SMPlayer"               --> doFloat
    , className =? "mpv"              --> doCenterFloat
    , className =? "feh"              --> doCenterFloat
    , className =? "Audacious"        --> doCenterFloat
    --, className =? "Thunar"           --> doCenterFloat
    , className =? "Websearch"        --> doCenterFloat
    , title     =? "urxvt_float"      --> doSideFloat SC
    , isFullscreen                    --> doFullFloat
    , isDialog                        --> doCenterFloat
    , stringProperty "WM_NAME" =? "LINE" --> (doRectFloat $ W.RationalRect 0.60 0.1 0.39 0.82)
    , stringProperty "WM_NAME" =? "Google Keep" --> (doRectFloat $ W.RationalRect 0.3 0.1 0.4 0.82)
    , stringProperty "WM_NAME" =? "tmptex.pdf - 1/1 (96 dpi)" --> (doRectFloat $ W.RationalRect 0.29 0.25 0.42 0.5)
    , stringProperty "WM_NAME" =? "Figure 1" --> doCenterFloat
    ]

--------------------------------------------------------------------------- }}}
-- myLogHook:         loghock settings                                      {{{
-------------------------------------------------------------------------------

myLogHook h = dynamicLogWithPP $ wsPP { ppOutput = hPutStrLn h }

--------------------------------------------------------------------------- }}}
-- myWsBar:           xmobar setting                                        {{{
-------------------------------------------------------------------------------

myWsBar = "xmobar -x 0 /home/xllauca/.config/dotfiles/xmobar/xmobarrc"

wsPP = xmobarPP { ppOrder           = \(ws:l:t:_)  -> [ws,l,t]
               , ppCurrent         = xmobarColor colorRed     colorNormalbg . \s -> "●"
               , ppUrgent          = xmobarColor colorGray    colorNormalbg . \s -> "●"
               , ppVisible         = xmobarColor colorRed     colorNormalbg . \s -> "⦿"
               , ppHidden          = xmobarColor colorGray    colorNormalbg . \s -> "●"
               , ppHiddenNoWindows = xmobarColor colorGray    colorNormalbg . \s -> "○"
              -- , ppTitle           = xmobarColor colorRed     colorNormalbg
               , ppTitle           =  (\str -> "")
               , ppOutput          = putStrLn
               , ppWsSep           = " "
               , ppSep             = "  "
                }

--------------------------------------------------------------------------- }}}                                         {
--------------------------------------------------------------------------- }}}
-- newMouse:          Right click is used for resizing window               {{{
-------------------------------------------------------------------------------

myMouse x = [ ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) ]
newMouse x = M.union (mouseBindings def x) (M.fromList (myMouse x))

--------------------------------------------------------------------------- }}}


-- vim: ft=haskell
