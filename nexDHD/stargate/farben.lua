-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD

local Theme, OC, CC = ...
local Farben = {}

if OC then
    Farben.graueFarbe          = 0x333333
    Farben.hellblau            = 0x336699
    Farben.mittelblau          = 0x6699FF
    Farben.roteFarbe           = 0xFF0000
    Farben.weisseFarbe         = 0xFFFFFF
    Farben.blaueFarbe          = 0x333399
    Farben.schwarzeFarbe       = 0x000000
    Farben.gelbeFarbe          = 0xFFCC33
    Farben.brauneFarbe         = 0x663300
    Farben.hellgrueneFarbe     = 0x00FF00
    Farben.grueneFarbe         = 0x336600
    Farben.orangeFarbe         = 0xFF7F24
elseif CC then
    Farben.graueFarbe          = 128
    Farben.hellblau            = 8
    Farben.mittelblau          = 512
    Farben.roteFarbe           = 16384
    Farben.weisseFarbe         = 1
    Farben.blaueFarbe          = 2048
    Farben.schwarzeFarbe       = 32768
    Farben.gelbeFarbe          = 16
    Farben.brauneFarbe         = 4096
    Farben.hellgrueneFarbe     = 32
    Farben.grueneFarbe         = 8192
    Farben.orangeFarbe         = 2
end

if Theme == "dunkel" then
    -- dark Theme here
else
    Farben.FehlerFarbe           = Farben.roteFarbe
    Farben.Hintergrundfarbe      = Farben.graueFarbe
    Farben.Trennlinienfarbe      = Farben.blaueFarbe
    Farben.Textfarbe             = Farben.weisseFarbe
    Farben.Logbuch_in            = Farben.roteFarbe
    Farben.Logbuch_intext        = Farben.schwarzeFarbe
    Farben.Logbuch_out           = Farben.grueneFarbe
    Farben.Logbuch_outtext       = Farben.weisseFarbe
    Farben.Logbuch_neu           = Farben.hellblau
    Farben.Logbuch_neutext       = Farben.weisseFarbe
    Farben.Logbuch_update        = Farben.gelbeFarbe
    Farben.Logbuch_updatetext    = Farben.schwarzeFarbe
    Farben.Adressfarbe           = Farben.brauneFarbe
    Farben.AdressfarbeAktiv      = Farben.hellblau
    Farben.AdressfarbeAktiv2     = Farben.mittelblau
    Farben.Adresstextfarbe       = Farben.Textfarbe
    Farben.Nachrichtfarbe        = Farben.graueFarbe
    Farben.Nachrichttextfarbe    = Farben.Textfarbe
    Farben.Steuerungsfarbe       = Farben.gelbeFarbe
    Farben.Steuerungstextfarbe   = Farben.schwarzeFarbe
    Farben.Statusfarbe           = Farben.grueneFarbe
    Farben.Statustextfarbe       = Farben.Textfarbe
end

Farben.white                 = 0
Farben.orange                = 1
Farben.magenta               = 2
Farben.lightblue             = 3
Farben.yellow                = 4
Farben.lime                  = 5
Farben.pink                  = 6
Farben.gray                  = 7
Farben.silver                = 8
Farben.cyan                  = 9
Farben.purple                = 10
Farben.blue                  = 11
Farben.brown                 = 12
Farben.green                 = 13
Farben.red                   = 14
Farben.black                 = 15

return Farben