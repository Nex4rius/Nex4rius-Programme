local OC , CC, graphicT3 = ...
local Farben = {}

if OC then
  Farben.graueFarbe      = 6684774
  Farben.hellblau        = 0x606060
  Farben.mittelblau      = 8421504
  Farben.roteFarbe       = 0xFF0000
  Farben.weisseFarbe     = 0xFFFFFF
  Farben.blaueFarbe      = 0x0000FF
  Farben.schwarzeFarbe   = 0x000000
  Farben.gelbeFarbe      = 16750899
  Farben.brauenFarbe     = 10046464
  Farben.grueneFarbe     = 39168
  if graphicT3 then
    Farben.graueFarbe    = 0x333333
    Farben.hellblau      = 0x336699
    Farben.mittelblau    = 0x6699FF
    Farben.roteFarbe     = 0xFF3333
    Farben.weisseFarbe   = 0xFFFFFF
    Farben.blaueFarbe    = 0x333399
    Farben.schwarzeFarbe = 0x000000
    Farben.gelbeFarbe    = 0xFFCC33
    Farben.brauenFarbe   = 0x663300
    Farben.grueneFarbe   = 0x336600
  end
elseif CC then
  Farben.graueFarbe      = 128
  Farben.hellblau        = 8
  Farben.mittelblau      = 512
  Farben.roteFarbe       = 16384
  Farben.weisseFarbe     = 1
  Farben.blaueFarbe      = 2048
  Farben.schwarzeFarbe   = 32768
  Farben.gelbeFarbe      = 16
  Farben.brauenFarbe     = 4096
  Farben.grueneFarbe     = 8192
end

return Farben
