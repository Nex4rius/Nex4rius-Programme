--
--   Configuration file
--
RF = false -- show energy in RF instead of EU
autoclosetime = 30 -- in seconds -- false for no autoclose
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
control = "On"
send = true
IDCyes = false

if RF == true then
  energytpye = "RF"
  energymultiplicator = 80
end
