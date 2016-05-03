--
--   don't change anything
--
component = require("component")
sg = component.getPrimary("stargate")
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
if component.isAvailable("redstone") then
  r = component.getPrimary("redstone")
  redst = true
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
else
  r = nil
  redst = false
end
redstoneIncoming = false
redstoneState = false
redstoneIDC = false

if RF == true then
  energytpye = "RF"
  energymultiplicator = 80
end
