-- written by Shotaro Fujimoto (https://github.com/ssh0)
-- written by Ogis (https://github.com/Minda1975)
-- written by Taurus Omar (https://github.com/TaurusOmar/)
-- modified and repaired by xllauca (https://github.com/xllauca)
--
--
import XMonad
import XMonad.Config.Desktop
import Data.Monoid
import Data.Maybe (isJust)
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Utilities
import XMonad.Util.Loggers
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Actions
import XMonad.Actions.Minimize (minimizeWindow)
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies, runOrCopy)
import XMonad.Actions.WindowGo (runOrRaise, raiseMaybe)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen, swapNextScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.DynamicWorkspaces (addWorkspacePrompt, removeEmptyWorkspace)
import XMonad.Actions.MouseResize
import qualified XMonad.Actions.ConstrainedResize as Sqr
import XMonad.Actions.WindowMenu
import XMonad.Actions.UpdatePointer

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)
import XMonad.Prompt.ConfirmPrompt

    -- Data
import Data.Char (isSpace)

    -- Layouts modifiers
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace))
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Spacing --(spacing)
import XMonad.Layout.NoBorders
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.Reflect (reflectVert, reflectHoriz, REFLECTX(..), REFLECTY(..))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), Toggle(..), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.OneBig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.ZoomRow (zoomRow, zoomIn, zoomOut, zoomReset, ZoomMessage(ZoomFullToggle))
import XMonad.Layout.IM (withIM, Property(Role))
import XMonad.Layout.Accordion
import XMonad.Layout.Cross

 -- Prompts
import XMonad.Prompt (defaultXPConfig, XPConfig(..), XPPosition(Top), Direction1D(..))
import XMonad.Prompt.Man
import XMonad.Prompt.AppendFile



myFont          = "xft:Hack Nerd Font Mono:weight=bold:pixelsize=11:antialias=true:hinting=true"
myModMask       = mod1Mask               -- Setear la tecla maestra / por defecto windows key
myTerminal      = "alacritty"       -- Terminal por defecto
--myTextEditor    = "code"                 -- Editor de texto por defecto
myBorderWidth   = 1                      -- Setear el tamano del borde
windowCount     = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/xllauca/.config/dotfiles/xmobar/xmobarrc0"
 -- xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrc0" --Descomentar para activar segunda pantalla
    xmonad $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat )   <+> myManageHook <+> manageHook desktopConfig <+> manageDocks
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput          = \x -> hPutStrLn xmproc0 x -- >> hPutStrLn xmproc1 x descomentar para segunda pantall
                        , ppCurrent         = xmobarColor "#8EC07C" "" . wrap "/" "/"
                        , ppVisible         = xmobarColor "#D79921" ""
                        , ppHidden          = xmobarColor "#D79921" "" . wrap "°" ""
                        , ppHiddenNoWindows = xmobarColor "#a89984" "" 
                        --, ppTitle           = xmobarColor "#FBF1C7" "" . shorten 60
                        , ppTitle           =  (\str -> "")
                        , ppSep             =  "<fc=#CC241D> => </fc>"
                        , ppUrgent          = xmobarColor "#cc241d" "" . wrap "!" "!"
                        , ppExtras          = [windowCount]
                        , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        } >>  updatePointer (0.5, 0.5) (0, 0)

        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = "#282828"
        , focusedBorderColor = "#427b58"
        } `additionalKeysP`         myKeys

------------------------------------------------------------
---                  AUTOSTART                           ---
------------------------------------------------------------
    --
myStartupHook = do
          --spawnOnce "picom &"
          --spawnOnce "nitrogen --restore &"
          --spawnOnce "volumeicon &"
          spawnOnce "flameshot &"
          --spawnOnce "xset r rate 200 25"
          setWMName "XMonad"
          --spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"
          spawnOnce "wmname LG3D"
          setWMName "LG3D"
          --spawnOnce "gnome-shell"
          spawnOnce "/home/xllauca/.config/dotfiles/scripts/autostart.sh"


---------------------------------------------------
---        CONFIGURACIONES DEL GRID             ---
---------------------------------------------------

--- Color del Grid
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x28,0x28)
                  (0x28,0x28,0x28)
                  (0x28,0x28,0x28)
                  (0xd5,0xc4,0xa1)
                  (0xff,0xff,0xff)

-- Tamano del grid
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 30
    , gs_cellwidth    = 200
    , gs_cellpadding  = 8
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = defaultGSConfig


----------------------------------------------------------------------------------
--                          XPROMPT Configuraciones                            ---
----------------------------------------------------------------------------------

xllaucaXPConfig :: XPConfig
xllaucaXPConfig = def
      { font                = myFont
      , bgColor             = "#282828"
      , fgColor             = "#FBF1C7"
      , bgHLight            = "#458588"
      , fgHLight            = "#ffffff"
      , borderColor         = "#DC9656"
      , promptBorderWidth   = 0
      , position            = Top
--    , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 10000
      , showCompletionOnTab = False
      --, searchPredicate     = isPrefixOf
      --, searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing
      }

xllaucaXPConfig' :: XPConfig
xllaucaXPConfig' = xllaucaXPConfig
      { autoComplete        = Nothing
      }
----------------------------------------------------------------------------------
--                  Funcion Buscar Ruta o Archivo                              ---
----------------------------------------------------------------------------------
    --
whereis :: XPConfig -> String -> X ()
whereis c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "whereis" [input] "") >>= whereis c
    where
        trim = f . f
            where f = reverse . dropWhile isSpace
----------------------------------------------------------------------------------
--                  Funcion Promt confirmar salida de Xmonad                   ---
----------------------------------------------------------------------------------
    --
exitPrompt :: X ()
exitPrompt = confirmPrompt xllaucaXPConfig "Quit XMonad?" $ io exitSuccess

----------------------------------------------------------------------------------
---                       COMBINACION DE TECLAS                                ---
----------------------------------------------------------------------------------

myKeys =
    -- configuraciones Xmonad
        [ ("M-C-r", spawn "xmonad --recompile")                             -- Recompilar xmonad
        , ("M-S-r", spawn "xmonad --restart")                               -- Restar xmonad
        , ("M-S-e", exitPrompt)                                             -- Salir de xmonad

    -- Acciones sobre las ventanas
        , ("M-q", kill1)                                                    -- Cerrar ventana
        , ("M-S-q", killAll)                                                -- Cerrar todas las ventanas
        , ("M-<Delete>", withFocused $ windows . W.sink)                    -- Restaurar ventna flotante


    -- Menu Browers
        --, (("M-C-i"), spawnSelected'
        --  [ --("Chrome", "google-chrome-stable")
        --    ("Firefox", "firefox")
        --  , ("Chromium", "chromium")
        --  , ("Qutebrowser", "qutebrowser")
          --, ("Tor", "exec-in-shell ~/tools/tor/./Browser/start-tor-browser --detach")
        --  ])
        
    -- Menu Grid Archivos - Editor
        --, (("M-C-o"), spawnSelected'
        --  [ ("VsCode", "code")
        --  , ("Vifm", "xfce4-terminal -e vifm")
        --  , ("Nautilus", "nautilus")
        --  , ("Telegram", "telegram-desktop")
        --  , ("Discord", "exec-in-shell ~/tools/Discord/Discord")
        --  ])
    

    -- Menu URLs
          , (("M-C-u"), spawnSelected'
          [ --("0day", "google-chrome-stable 0day.today")
            ("HackTheBox", "firefox app.hackthebox.eu")
          , ("TryHackMe", "firefox tryhackme.com")
          , ("PacketStorm", "firefox packetstormsecurity.com")
          , ("GTFOBins", "firefox gtfobins.github.io")
          --, ("TaurusOmar", "google-chrome-stable taurusomar.com")
          , ("GitHub ", "firefox github.com/xllauca")
          ])


    -- Menu Tools
          , (("M-C-p"), spawnSelected'
          [ 
             ("BurpSuite", "/bin/java --illegal-access=permit -jar /usr/share/burpsuite/burpsuite.jar")
           , ("Sqlmap", "alacritty -e zsh -c 'exec-in-shell sqlmap'")
           , ("Subfinder", "alacritty -e zsh -c 'exec-in-shell subfinder'")
           , ("Httpx", "alacritty -e zsh -c 'exec-in-shell httpx'")
           , ("Amss", "alacritty -e zsh -c 'exec-in-shell amass'")
           , ("Zap Proxy", "java -Xmx974m -jar /usr/share/zaproxy/zap-2.10.0.jar")
           , ("Ffuf", "alacritty -e zsh -c 'exec-in-shell ffuf'")
           , ("Nmap", "alacritty -e zsh -c 'exec-in-shell nmap'")
           , ("Dirsearch", "alacritty -e zsh -c 'exec-in-shell dirsearch.py'")
           , ("Nuclei", "alacritty -e zsh -c 'exec-in-shell nuclei'")
           , ("Paramspider", "alacritty -e zsh -c 'exec-in-shell paramspider'")
           , ("Sublist3r", "alacritty -e zsh -c 'exec-in-shell sublist3r'")
           , ("Gobuster", "alacritty -e zsh -c 'exec-in-shell gobuster'")
           , ("Wfuzz", "alacritty -e zsh -c 'exec-in-shell wfuzz'")
           , ("GitRob", "alacritty -e zsh -c 'exec-in-shell gitrob -h'")
           , ("Joomscan", "alacritty -e zsh -c 'exec-in-shell joomscan'")
           , ("Wpscan", "alacritty -e zsh -c 'exec-in-shell wpscan -h'") 
           , ("Rustscan", "alacritty -e zsh -c 'exec-in-shell rustscan'")
           , ("Httprobe", "alacritty -e zsh -c 'exec-in-shell httprobe -h'")
           , ("getJS", "alacritty -e zsh -c 'exec-in-shell getJS -h'")
           , ("Arjun", "alacritty -e zsh -c 'exec-in-shell arjun'")
           , ("Crlfuzz", "alacritty -e zsh -c 'exec-in-shell crlfuzz'")
           , ("Xsrfprobe", "alacritty -e zsh -c 'exec-in-shell xsrfprobe'")
           , ("Liffy", "alacritty -e zsh -c 'exec-in-shell liffy'")
           , ("GraphQLmap", "alacritty -e zsh -c 'exec-in-shell graphqlmap'")
           , ("Dom Red", "alacritty -e zsh -c 'exec-in-shell domred'")
           , ("OpenRedireX", "alacritty -e zsh -c 'exec-in-shell openredirex'")
           , ("Smuggler", "alacritty -e zsh -c 'exec-in-shell smuggler'")
           , ("SSRFmap", "alacritty -e zsh -c 'exec-in-shell ssrfmap'")
           , ("HashCcat", "alacritty -e zsh -c 'exec-in-shell hashcat'")
           , ("BruteMap", "alacritty -e zsh -c 'exec-in-shell brutemap'")
           , ("Request-Smuggler", "alacritty -e zsh -c 'exec-in-shell requestsmuggler'")           
           , ("Furious", "alacritty -e zsh -c 'exec-in-shell furious -h'")
           , ("Cerbrutus", "alacritty -e zsh -c 'exec-in-shell python /opt/tools/cerbrutus/cerbrutus/cerbrutus.py -h'")
           , ("AppkLeaks", "alacritty -e zsh -c 'exec-in-shell apkleaks'")
           , ("JWT_Tool", "alacritty -e zsh -c 'exec-in-shell jwt_tool'")
           , ("Jexboss", "alacritty -e zsh -c 'exec-in-shell jexboss'")
           , ("Waybackurls", "alacritty -e zsh -c 'exec-in-shell waybackurls -h'")
           , ("Patator", "alacritty -e zsh -c 'exec-in-shell patator'")
           , ("Didar", "alacritty -e zsh -c 'exec-in-shell dirdar -h'")
           , ("Bypass 403", "alacritty -e zsh -c 'exec-in-shell bypass-403'")
           , ("DirBuster", "java -jar /usr/share/dirbuster/DirBuster-1.0-RC1.jar")
           , ("Hash-Buster", "alacritty -e zsh -c 'exec-in-shell hashbuster'")
           , ("Crackmapexec", "alacritty -e zsh -c 'exec-in-shell crackmapexec'")
           , ("Deathstar", "alacritty -e zsh -c 'exec-in-shell deathstar'")
           , ("Cloudfail", "alacritty -e zsh -c 'exec-in-shell cloudfail -h 2>/dev/null'")
           , ("Linkfinder", "alacritty -e zsh -c 'exec-in-shell linkfinder'")
           , ("Subzy", "alacritty -e zsh -c 'exec-in-shell subzy'")
           , ("Shellerator", "alacritty -e zsh -c 'exec-in-shell shellerator -h'")
           , ("Enum4linux", "alacritty -e zsh -c 'exec-in-shell enum4linux-ng'")
           , ("Dnsenum", "alacritty -e zsh -c 'exec-in-shell dnsenum'")
           , ("Metasploit", "alacritty -e zsh -c 'exec-in-shell  msfconsole'")
           , ("Pwncat", "alacritty -e zsh -c 'exec-in-shell  ~/testing.sh 2&>/dev/null &'")


          ])

    -- Run Prompt
        , ("M-C-<Return>", shellPrompt xllaucaXPConfig)                                    -- Abrir shellPrompt
        , ("M-C-w", whereis xllaucaXPConfig "whereis")                                     -- Buscar Path
        , ("M-C-s", sshPrompt xllaucaXPConfig)                                             -- Conexion SSH
        , ("M-C-g", goToSelected $ mygridConfig myColorizer)                               -- Ir a la ventana
        , ("M-C-b", bringSelected $ mygridConfig myColorizer)                              -- Traer Ventana al espacion de trabajo
        , ("M-C-h", manPrompt xllaucaXPConfig)                                             -- Comando man 
        , ("M-C-n", appendFilePrompt xllaucaXPConfig "/home/xllauca/notas.txt")   -- Agregar notas rapidas
       -- , ("M-C-p", windowMenu)

    -- Navegacion de ventanas
        , ("M-m", windows W.focusMaster)                                                -- Focus a la princial ventana
        , ("M-<Down>", windows W.focusDown)                                             -- Focus a la siguiente ventana
        , ("M-<Up>", windows W.focusUp)                                                 -- Focus a la ventana anterior
        , ("M-S-<Down>", windows W.swapDown)                                            -- Cambiar posicion de ventana hacia abajo
        , ("M-S-<Up>", windows W.swapUp)                                                -- Cambiar posicion de ventana hacia arriba
        , ("M-<Backspace>", promote)                                                    -- Mover la ventana como master principal
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)                   -- Cambiar ventana en el siguiente grupo de trabajo (tecla +)
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)              -- Cambiar ventana al anterior grupo de trabajo (tecla -)


    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                                        -- Cambiar de diseno de ventanas
        , ("M-S-f", sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts)         -- Ventana todo pantalla
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))                            -- Incrementar el numero de venatas para un grupo de trabajo o dividir pantall vertical
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))                           -- Decrementar el numero de venatas para un grupo de trabajo o dividir pantall horizontal
        , ("M-S-<KP_Multiply>", increaseLimit)                                       -- Mover para de ventana para delante por los diferentes grupos de trabajo
        , ("M-S-<KP_Divide>", decreaseLimit)                                         -- Mover para de ventana para atras por los diferentes grupos de trabajo
        , ("M-S-<Left>", sendMessage Shrink)                                         -- Aumentar tamano de ancho izquierda
        , ("M-S-<Right>", sendMessage Expand)                                        -- Aumentar tamano de ancho derecha

    -- Para varios monitores
       -- , ("M-.", nextScreen)                                                      -- Cambiar al siguiente monitor
       -- , ("M-,", prevScreen)                                                      -- Cambiar al monitor previo

    --- Programas
        , ("M-b", spawn "/bin/java --illegal-access=permit -jar /usr/share/burpsuite/burpsuite.jar")
        , ("M-f", spawn "firefox")
        , ("M-p", spawn "flameshot gui")
        , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))


    -- Media Keys
    --    , ("<XF86AudioPlay>", spawn "deadbeef --play-pause")
    --    , ("<XF86AudioStop>", spawn "deadbeef --stop")
    --    , ("<XF86AudioPrev>", spawn "deadbeef --prev")
    --    , ("<XF86AudioNext>", spawn "deadbeef --next")
    --    , ("<XF86MonBrightnessUp>", spawn "bright")
    --    , ("<XF86MonBrightnessDown>", spawn "bright -d")
    --    , ("<XF86AudioMute>",   spawn "amixer set Master toggle")
    --    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    --    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    --    , ("<XF86HomePage>", spawn "qutebrowser")
    --    , ("<XF86Search>", safeSpawn "qutebrowser" ["https://www.duckduckgo.com/"])
    --    , ("<XF86Mail>", runOrRaise "geary" (resource =? "thunderbird"))
    --    , ("<XF86Calculator>", runOrRaise "gcalctool" (resource =? "gcalctool"))
    --    , ("<XF86Eject>", spawn "toggleeject")
    --   , ("<Print>", spawn "scrotd 0")
        ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))


----------------------------------------------------------------------------------
---                        ESPACIOS DE TRABAJO                                 ---
----------------------------------------------------------------------------------
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               $ ["●", "●", "●", "●", "●", "●", "●", "●", "●"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [
      className =? "qutebrowser"                  --> doShift "<action=xdotool key super+2>www</action>"
      --, title =? "New Tab-Google Chrome"          --> doShift "<action=xdotool key super+1>www</action>"
      --, title =? "Mozilla Firefox"                --> doShift "<action=xdotool key super+1>www</action>"
      --, title =? "pcmanfm"                        --> doShift "<action=xdotool key super+4>file</action>"
      --, className =? "code"                       --> doShift "<action=xdotool key super+7>code</action>"
      --, className =? "vlc"                        --> doShift "<action=xdotool key super+7>media</action>"
      --, className =? "Virtualbox"                 --> doFloat
      --, className =? "Gimp"                       --> doFloat
      --, className =? "Gimp"                       --> doShift "<action=xdotool key super+8>misc</action>"
     -- , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ]

----------------------------------------------------------------------------------
---                      DISENO DE ESPACIOS DE TRABAJO                         ---
----------------------------------------------------------------------------------
myLayoutHook =  avoidStruts $ mouseResize $ windowArrange $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where
                  myDefaultLayout = tall ||| Accordion

-- Descomentar para agregar mas disenos
tall      = renamed [Replace "T"]     $ limitWindows 12 $ spacing 6 $ ResizableTall 1 (3/100) (1/2) []
--  myDefaultLayout = tall ||| grid ||| threeCol ||| threeRow ||| oneBig ||| noBorders monocle ||| space ||| floats
--tall         = renamed [Replace "T"] $ limitWindows 12 $ ResizableTall 1 (3/100) (1/2) []
--grid       = renamed [Replace "G"]     $ limitWindows 12 $ mkToggle (single MIRROR) $ Grid (16/10)
--threeCol   = renamed [Replace "TC"] $ limitWindows 3  $ ThreeCol 1 (3/100) (1/2)
--threeRow   = renamed [Replace "threeRow"] $ limitWindows 3  $ Mirror $ mkToggle (single MIRROR) zoomRow
--oneBig     = renamed [Replace "oneBig"]   $ limitWindows 6  $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (5/9) (8/12)
--monocle      = renamed [Replace "M"]  $ limitWindows 20 $ Full
--space      = renamed [Replace "space"]    $ limitWindows 4  $ spacing 12 $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (2/3) (2/3)
--floats       = renamed [Replace "F"]   $ limitWindows 20 $ simplestFloat
 