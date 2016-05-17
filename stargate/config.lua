time = "-"
incode = "-"
wormhole = "in"
a = os.time()
os.sleep(1)
sectime = a - os.time()
activationtime = 0
entercode = false
enteridc = ""
showidc = ""
iriscontrol = "on"
codeaccepted = "-"
energytype = "EU"
energymultiplicator = 20
energy = 0
send = true
IDCyes = false
seite = 0
maxseiten = 0
zeile = 1
remoteName = ""
checkEnergy = 0
AddNewAddress = true
roteFarbe = 0xFF0000
weisseFarbe = 0xFFFFFF
blaueFarbe = 0x0000FF
schwarzeFarbe = 0x00000
Trennlinienfarbe = blaueFarbe
Hintergrundfarbe = 0x333333

if redst == true then
  white = 0
  orange = 1
  magenta = 2
  lightblue = 3
  yellow = 4
  lime = 5
  pink = 6
  gray = 7
  silver = 8
  cyan = 9
  purple = 10
  blue = 11
  brown = 12
  green = 13
  red = 14
  black = 15
  for farbe = 0, 15 do
    r.setBundledOutput(0, farbe, 0)
  end
end

redstoneConnected = false
redstoneIncoming = false
redstoneState = false
redstoneIDC = false

IrisZustandName = irisNameOffline

if RF == true then
  energytpye = "RF"
  energymultiplicator = 80
end

os.sleep(2)
