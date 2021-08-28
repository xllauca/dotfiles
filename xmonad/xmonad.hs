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
import XMonad.Layout.Spacing (spacing)
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
myTerminal      = "xfce4-terminal"       -- Terminal por defecto
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
                        , ppCurrent         = xmobarColor "#8EC07C" "" . \s -> "●"
                        , ppVisible         = xmobarColor "#D79921" "" . \s -> "⦿"
                        , ppHidden          = xmobarColor "#D79921" "" . \s -> "●"
                        , ppHiddenNoWindows = xmobarColor "#a89984" "" . \s -> "○"
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
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"
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

<<<<<<< HEAD
--
-- Autostart
myStartupHook = do
    spawn "/home/xllauca/.config/dotfiles/scripts/autostart.sh"
    setWMName "LG3D"
=======
>>>>>>> master


----------------------------------------------------------------------------------
--                          XPROMPT Configuraciones                            ---
----------------------------------------------------------------------------------

xllaucaXPConfig :: XPConfig
xllaucaXPConfig = def
      { font                = myFont
      , bgColor             = "#282828"
      , fgColor             = "#EBDBB2"
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
             ("BurpSuite", "/bin/java -jar /usr/share/burpsuite/burpsuite.jar")
           , ("Sqlmap", "xfce4-terminal --execute zsh -c 'exec-in-shell sqlmap'")
           , ("Subfinder", "xfce4-terminal --execute zsh -c 'exec-in-shell subfinder'")
           , ("Httpx", "xfce4-terminal --execute zsh -c 'exec-in-shell httpx'")
           , ("Amss", "xfce4-terminal --execute zsh -c 'exec-in-shell amass'")
           , ("Zap Proxy", "java -Xmx974m -jar /usr/share/zaproxy/zap-2.10.0.jar")
           , ("Ffuf - Fuzz", "xfce4-terminal --execute zsh -c 'exec-in-shell ffuf'")
           , ("Nmap", "xfce4-terminal --execute zsh -c 'exec-in-shell nmap'")
           , ("Dirsearch", "xfce4-terminal --execute zsh -c 'exec-in-shell dirsearch -h'")
           , ("Nuclei", "xfce4-terminal --execute zsh -c 'exec-in-shell nuclei'")
           , ("Paramspider", "xfce4-terminal --execute zsh -c 'exec-in-shell /home/xllauca/ParamSpider/paramspider.py -h'")
           , ("Sublist3r", "xfce4-terminal --execute zsh -c 'exec-in-shell sublist3r'")
           , ("Gobuster", "xfce4-terminal --execute zsh -c 'exec-in-shell gobuster'")
           , ("Wfuzz", "xfce4-terminal --execute zsh -c 'exec-in-shell wfuzz'")
           , ("GitRob", "xfce4-terminal --execute zsh -c 'exec-in-shell gitrob -h'")
           , ("Joomscan", "xfce4-terminal --execute zsh -c 'exec-in-shell joomscan'")
           , ("Wpscan", "xfce4-terminal --execute zsh -c 'exec-in-shell wpscan -h'") 
           , ("Rustscan", "xfce4-terminal --execute zsh -c 'exec-in-shell rustscan'")
           , ("Httprobe", "xfce4-terminal --execute zsh -c 'exec-in-shell httprobe -h'")
           , ("getJS", "xfce4-terminal --execute zsh -c 'exec-in-shell getJS -h'")
           , ("Arjun", "xfce4-terminal --execute zsh -c 'exec-in-shell arjun'")
           , ("Crlfuzz", "xfce4-terminal --execute zsh -c 'exec-in-shell crlfuzz'")
           , ("Xsrfprobe", "xfce4-terminal --execute zsh -c 'exec-in-shell xsrfprobe'")
           , ("Liffy", "xfce4-terminal --execute zsh -c 'exec-in-shell liffy'")
           , ("GraphQLmap", "xfce4-terminal --execute zsh -c 'exec-in-shell graphqlmap'")
           , ("Dom Red", "xfce4-terminal --execute zsh -c 'exec-in-shell python /home/xllauca/dom-red/dom-red.py -h'")
           , ("OpenRedireX", "xfce4-terminal --execute zsh -c 'exec-in-shell python /home/xllauca/dom-red/OpenRedireX/openredirex.py -h'")
           , ("Smuggler", "xfce4-terminal --execute zsh -c 'exec-in-shell smuggler'")
           , ("SSRFmap", "xfce4-terminal --execute zsh -c 'exec-in-shell ssrfmap'")
           , ("HashCcat", "xfce4-terminal --execute zsh -c 'exec-in-shell hashcat'")
           --, ("BruteMap", "xfce4-terminal --execute zsh -c 'exec-in-shell python3 ~/tools/web/brutemap/brutemap.py'")
           , ("Furious", "xfce4-terminal --execute zsh -c 'exec-in-shell furious -h'")
           , ("Cerbrutus", "xfce4-terminal --execute zsh -c 'exec-in-shell python /opt/cerbrutus/cerbrutus.py --help'")
           , ("AppkLeaks", "xfce4-terminal --execute zsh -c 'exec-in-shell apkleaks'")
           , ("JWT_Tool", "xfce4-terminal --execute zsh -c 'exec-in-shell python /home/xllauca/jwt_tool/jwt_tool.py'")
           , ("Jexboss", "xfce4-terminal --execute zsh -c 'exec-in-shell sudo jexboss'")
           , ("Waybackurls", "xfce4-terminal --execute zsh -c 'exec-in-shell waybackurls -h'")
           , ("Patator", "xfce4-terminal --execute zsh -c 'exec-in-shell patator'")
           , ("Didar", "xfce4-terminal --execute zsh -c 'exec-in-shell dirdar -h'")
           , ("Bypass 403", "xfce4-terminal --execute zsh -c 'exec-in-shell bypass-403.sh'")
           , ("DirBuster", "java -jar ~/tools/web/dirbuster/DirBuster-0.12.jar")
           , ("Hash-Buster", "java -jar /usr/share/dirbuster/DirBuster-1.0-RC1.jar")
           , ("Crackmapexec", "xfce4-terminal --execute zsh -c 'exec-in-shell crackmapexec'")
           , ("Deathstar", "xfce4-terminal --execute zsh -c 'exec-in-shell deathstar'")
           , ("Cloudfail", "xfce4-terminal --execute zsh -c 'exec-in-shell cloudfail -h 2>/dev/null'")
           , ("Linkfinder", "xfce4-terminal --execute zsh -c 'exec-in-shell linkfinder'")
           , ("Subzy", "xfce4-terminal --execute zsh -c 'exec-in-shell subzy'")
           , ("Shellerator", "xfce4-terminal --execute zsh -c 'exec-in-shell shellerator -h'")
           , ("Enum4linux", "xfce4-terminal --execute zsh -c 'exec-in-shell  enum4linux-ng'")
           , ("Metasploit", "xfce4-terminal --execute zsh -c 'exec-in-shell  msfconsole'")


          ])

    -- Run Prompt
        , ("M-C-<Return>", shellPrompt xllaucaXPConfig)                                    -- Abrir shellPrompt
        , ("M-C-w", whereis xllaucaXPConfig "whereis")                                     -- Buscar Path
        , ("M-C-s", sshPrompt xllaucaXPConfig)                                             -- Conexion SSH
        , ("M-C-g", goToSelected $ mygridConfig myColorizer)                            -- Ir a la ventana
        , ("M-C-b", bringSelected $ mygridConfig myColorizer)                           -- Traer Ventana al espacion de trabajo
        , ("M-C-h", manPrompt xllaucaXPConfig)                                             -- Comando man 
        , ("M-C-n", appendFilePrompt xllaucaXPConfig "home/xllauca/Documents/notas.txt")         -- Agregar notas rapidas
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
        , ("M-d", spawn "rofi -show run")
        , ("M-f", spawn "firefox")
        , ("M-p", spawn "flameshot gui")
        , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))


    -- Media Keys
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

<<<<<<< HEAD
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
=======

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
               $ [" www ", " term ", " code ", " file ", " chat ", " vpn ", "spfy", "", "vbox"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [
      className =? "qutebrowser"                  --> doShift "<action=xdotool key super+2>www</action>"
      , title =? "New Tab-Google Chrome"          --> doShift "<action=xdotool key super+1>www</action>"
      , title =? "Mozilla Firefox"                --> doShift "<action=xdotool key super+1>www</action>"
      , title =? "pcmanfm"                        --> doShift "<action=xdotool key super+4>file</action>"
      , className =? "code"                       --> doShift "<action=xdotool key super+7>code</action>"
      , className =? "vlc"                        --> doShift "<action=xdotool key super+7>media</action>"
      , className =? "Virtualbox"                 --> doFloat
      , className =? "Gimp"                       --> doFloat
      , className =? "Gimp"                       --> doShift "<action=xdotool key super+8>misc</action>"
     -- , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ]

----------------------------------------------------------------------------------
---                      DISENO DE ESPACIOS DE TRABAJO                         ---
----------------------------------------------------------------------------------
myLayoutHook =  avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where
                  myDefaultLayout = tall ||| Accordion ||| noBorders monocle

-- Descomentar para agregar mas disenos
--  myDefaultLayout = tall ||| grid ||| threeCol ||| threeRow ||| oneBig ||| noBorders monocle ||| space ||| floats
tall         = renamed [Replace "T"]     $ limitWindows 12 $ spacing 6 $ ResizableTall 1 (3/100) (1/2) []
grid       = renamed [Replace "G"]     $ limitWindows 12 $ spacing 6 $ mkToggle (single MIRROR) $ Grid (16/10)
threeCol   = renamed [Replace "TC"] $ limitWindows 3  $ ThreeCol 1 (3/100) (1/2)
--threeRow   = renamed [Replace "threeRow"] $ limitWindows 3  $ Mirror $ mkToggle (single MIRROR) zoomRow
--oneBig     = renamed [Replace "oneBig"]   $ limitWindows 6  $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (5/9) (8/12)
monocle      = renamed [Replace "M"]  $ limitWindows 20 $ Full
--space      = renamed [Replace "space"]    $ limitWindows 4  $ spacing 12 $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (2/3) (2/3)
floats       = renamed [Replace "F"]   $ limitWindows 20 $ simplestFloat

>>>>>>> master
