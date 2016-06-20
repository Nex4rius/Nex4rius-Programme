-- pastebin run -f fa9gu1GJ
-- von Nex4rius

ZeitBeimEinschalten   = os.time()
os.sleep(1)
sectime               = ZeitBeimEinschalten - os.time()
letzteNachricht       = os.time()
letzterAdressCheck    = os.time() / sectime
enteridc              = ""
showidc               = ""
remoteName            = ""
time                  = "-"
incode                = "-"
codeaccepted          = "-"
wormhole              = "in"
iriscontrol           = "on"
energytype            = "EU"
activationtime        = 0
energy                = 0
seite                 = 0
maxseiten             = 0
checkEnergy           = 0
zeile                 = 1
energymultiplicator   = 20
xVerschiebung         = 33
AddNewAddress         = true
messageshow           = true
running               = true
send                  = true
IDCyes                = false
entercode             = false
redstoneConnected     = false
redstoneIncoming      = false
redstoneState         = false
redstoneIDC           = false
IrisZustandName       = irisNameOffline

graueFarbe            = 6684774
roteFarbe             = 0xFF0000
weisseFarbe           = 0xFFFFFF
blaueFarbe            = 0x0000FF
schwarzeFarbe         = 0x00000
gelbeFarbe            = 16750899
brauenFarbe           = 10046464
grueneFarbe           = 39168

FehlerFarbe           = roteFarbe
Hintergrundfarbe      = graueFarbe
Trennlinienfarbe      = blaueFarbe
Textfarbe             = weisseFarbe

Adressfarbe           = brauenFarbe
Adresstextfarbe       = Textfarbe
Nachrichtfarbe        = graueFarbe
Nachrichttextfarbe    = Textfarbe
Steuerungsfarbe       = gelbeFarbe
Steuerungstextfarbe   = schwarzeFarbe
Statusfarbe           = grueneFarbe
Statustextfarbe       = Textfarbe

ZeitBeimEinschalten   = nil

if redst == true then
  white               = 0
  r.setBundledOutput(0, white, 0)
--  orange              = 1
--  r.setBundledOutput(0, orange, 0)
--  magenta             = 2
--  r.setBundledOutput(0, magenta, 0)
--  lightblue           = 3
--  r.setBundledOutput(0, lightblue, 0)
  yellow              = 4
  r.setBundledOutput(0, yellow, 0)
--  lime                = 5
--  r.setBundledOutput(0, lime, 0)
--  pink                = 6
--  r.setBundledOutput(0, pink, 0)
--  gray                = 7
--  r.setBundledOutput(0, gray, 0)
--  silver              = 8
--  r.setBundledOutput(0, silver, 0)
--  cyan                = 9
--  r.setBundledOutput(0, cyan, 0)
--  purple              = 10
--  r.setBundledOutput(0, purple, 0)
--  blue                = 11
--  r.setBundledOutput(0, blue, 0)
--  brown               = 12
--  r.setBundledOutput(0, brown, 0)
  green               = 13
  r.setBundledOutput(0, green, 0)
  red                 = 14
  r.setBundledOutput(0, red, 0)
  black               = 15
  r.setBundledOutput(0, black, 0)
end

if RF == true then
  energytype          = "RF"
  energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  Trennlinienhoehe    = 13
else
  Trennlinienhoehe    = 14
end
