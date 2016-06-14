ZeitBeimEinschalten   = os.time()
os.sleep(1)
sectime               = ZeitBeimEinschalten - os.time()
letzteNachricht       = os.time()
gespeicherteAdressen  = {}
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

ErrorFarbe            = roteFarbe
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

if redst == true then
  white               = 0
  orange              = 1
  magenta             = 2
  lightblue           = 3
  yellow              = 4
  lime                = 5
  pink                = 6
  gray                = 7
  silver              = 8
  cyan                = 9
  purple              = 10
  blue                = 11
  brown               = 12
  green               = 13
  red                 = 14
  black               = 15
  for farbe = 0, 15 do
    r.setBundledOutput(0, farbe, 0)
  end
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

os.sleep(2)
