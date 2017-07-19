local OC , CC, graphicT3 = ...
local Farben = {}

if OC then
  Farben.graueFarbe        = 6684774
  Farben.hellblau          = 0x606060
  Farben.mittelblau        = 8421504
  Farben.roteFarbe         = 0xFF0000
  Farben.weisseFarbe       = 0xFFFFFF
  Farben.blaueFarbe        = 0x0000FF
  Farben.schwarzeFarbe     = 0x000000
  Farben.gelbeFarbe        = 16750899
  Farben.brauenFarbe       = 10046464
  Farben.grueneFarbe       = 39168
  if graphicT3 then
    Farben.graueFarbe      = 0x333333
    Farben.hellblau        = 0x336699
    Farben.mittelblau      = 0x6699FF
    Farben.roteFarbe       = 0xFF3333
    Farben.weisseFarbe     = 0xFFFFFF
    Farben.blaueFarbe      = 0x333399
    Farben.schwarzeFarbe   = 0x000000
    Farben.gelbeFarbe      = 0xFFCC33
    Farben.brauenFarbe     = 0x663300
    Farben.grueneFarbe     = 0x336600
  end
elseif CC then
  Farben.graueFarbe        = 128
  Farben.hellblau          = 8
  Farben.mittelblau        = 512
  Farben.roteFarbe         = 16384
  Farben.weisseFarbe       = 1
  Farben.blaueFarbe        = 2048
  Farben.schwarzeFarbe     = 32768
  Farben.gelbeFarbe        = 16
  Farben.brauenFarbe       = 4096
  Farben.grueneFarbe       = 8192
end

Farben.FehlerFarbe         = Farben.roteFarbe
Farben.Hintergrundfarbe    = Farben.graueFarbe
Farben.Trennlinienfarbe    = Farben.blaueFarbe
Farben.Textfarbe           = Farben.weisseFarbe

Farben.Adressfarbe         = Farben.brauenFarbe
Farben.AdressfarbeAktiv    = Farben.hellblau
Farben.Adresstextfarbe     = Farben.Textfarbe
Farben.Nachrichtfarbe      = Farben.graueFarbe
Farben.Nachrichttextfarbe  = Farben.Textfarbe
Farben.Steuerungsfarbe     = Farben.gelbeFarbe
Farben.Steuerungstextfarbe = Farben.schwarzeFarbe
Farben.Statusfarbe         = Farben.grueneFarbe
Farben.Statustextfarbe     = Farben.Textfarbe

Farben.white               = 0
--Farben.orange              = 1
--Farben.magenta             = 2
--Farben.lightblue           = 3
Farben.yellow              = 4
--Farben.lime                = 5
--Farben.pink                = 6
--Farben.gray                = 7
--Farben.silver              = 8
--Farben.cyan                = 9
--Farben.purple              = 10
--Farben.blue                = 11
--Farben.brown               = 12
Farben.green               = 13
Farben.red                 = 14
Farben.black               = 15

return Farben
