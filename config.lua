--
--   Configuration file
--
RF = false -- show energy in RF instead of EU
autoclosetime = 60 -- in seconds -- false for no autoclose
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
control = "On"
send = true
IDCyes = false
seite = 0
maxseiten = 0
zeile = 1
remoteName = ""
checkEnergy = 0
AddNewAddress = true

if RF == true then
  energytpye = "RF"
  energymultiplicator = 80
end
