--  pastebin run -f fa9gu1GJ
--  von Nex4rius

local sectime               = os.time()
os.sleep(1)
local sectime               = sectime - os.time()
local letzteNachricht       = os.time()
local letzterAdressCheck    = os.time() / sectime
local enteridc              = ""
local showidc               = ""
local remoteName            = ""
local time                  = "-"
local incode                = "-"
local codeaccepted          = "-"
local wormhole              = "in"
local iriscontrol           = "on"
local energytype            = "EU"
local activationtime        = 0
local energy                = 0
local seite                 = 0
local maxseiten             = 0
local checkEnergy           = 0
local zeile                 = 1
local energymultiplicator   = 20
local xVerschiebung         = 33
local AddNewAddress         = true
local messageshow           = true
local running               = true
local send                  = true
local IDCyes                = false
local entercode             = false
local redstoneConnected     = false
local redstoneIncoming      = false
local redstoneState         = false
local redstoneIDC           = false
local IrisZustandName       = irisNameOffline

local graueFarbe            = 6684774
local roteFarbe             = 0xFF0000
local weisseFarbe           = 0xFFFFFF
local blaueFarbe            = 0x0000FF
local schwarzeFarbe         = 0x00000
local gelbeFarbe            = 16750899
local brauenFarbe           = 10046464
local grueneFarbe           = 39168

local FehlerFarbe           = roteFarbe
local Hintergrundfarbe      = graueFarbe
local Trennlinienfarbe      = blaueFarbe
local Textfarbe             = weisseFarbe

local Adressfarbe           = brauenFarbe
local Adresstextfarbe       = Textfarbe
local Nachrichtfarbe        = graueFarbe
local Nachrichttextfarbe    = Textfarbe
local Steuerungsfarbe       = gelbeFarbe
local Steuerungstextfarbe   = schwarzeFarbe
local Statusfarbe           = grueneFarbe
local Statustextfarbe       = Textfarbe

if redst == true then
  local white               = 0
  r.setBundledOutput(0, white, 0)
--  local orange              = 1
--  r.setBundledOutput(0, orange, 0)
--  local magenta             = 2
--  r.setBundledOutput(0, magenta, 0)
--  local lightblue           = 3
--  r.setBundledOutput(0, lightblue, 0)
  local yellow              = 4
  r.setBundledOutput(0, yellow, 0)
--  local lime                = 5
--  r.setBundledOutput(0, lime, 0)
--  local pink                = 6
--  r.setBundledOutput(0, pink, 0)
--  local gray                = 7
--  r.setBundledOutput(0, gray, 0)
--  local silver              = 8
--  r.setBundledOutput(0, silver, 0)
--  local cyan                = 9
--  r.setBundledOutput(0, cyan, 0)
--  local purple              = 10
--  r.setBundledOutput(0, purple, 0)
--  local blue                = 11
--  r.setBundledOutput(0, blue, 0)
--  local brown               = 12
--  r.setBundledOutput(0, brown, 0)
  local green               = 13
  r.setBundledOutput(0, green, 0)
  local red                 = 14
  r.setBundledOutput(0, red, 0)
  local black               = 15
  r.setBundledOutput(0, black, 0)
end

if RF == true then
  local energytype          = "RF"
  local energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  local Trennlinienhoehe    = 13
else
  local Trennlinienhoehe    = 14
end

dofile("/stargate/Kontrollprogramm.lua")
