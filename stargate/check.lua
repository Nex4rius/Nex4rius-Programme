version = "1.4.5"
component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")

function checkComponents()
  if component.isAvailable("redstone") then
    print("- Redstone Card        ok (optional)")
    r = component.getPrimary("redstone")
    redst = true
  else
    print("- Redstone Card        Missing (optional)")
    r = nil
    redst = false
  end
  if gpu.maxResolution() > 50 then
    print("- GPU Tier2+           ok")
    gpu = component.getPrimary("gpu")
  else
    print("- GPU Tier2+           Missing")
  end
  if component.isAvailable("internet") then
    print("- Internet             ok (optional)")
    internet = true
  else
    print("- Internet             Missing (optional)")
    internet = false
  end
  if component.isAvailable("stargate") then
    print("- Stargate             ok")
    sg = component.getPrimary("stargate")
  else
    print("- Stargate             Missing")
    return false
  end
end

function update()
  fs.makeDirectory("/stargate")
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/autorun.lua' autorun.lua")
  print("")
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/control.lua' stargate/control.lua")
  print("")
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/compat.lua' stargate/compat.lua")
  print("")
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/config.lua' stargate/config.lua")
  print("")
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/check.lua' stargate/check.lua")
  print("")
  os.execute("wget 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/addresses.lua' stargate/addresses.lua")
  print("")
  os.execute("wget 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/saveAfterReboot.lua' stargate/saveAfterReboot.lua")
  print("")
  f = io.open ("stargate/addresses.lua", "r")
  readAddresses = f:read(10000)
  AdressesLength = string.len(readAddresses)
  f:close ()
  if string.sub(readAddresses, AdressesLength, AdressesLength) == " " then
    f = io.open ("stargate/addresses.lua", "a")
    f:seek ("end", -1)
    f:write("")
    f:close ()
  end
--  os.execute("reboot")
end

if checkComponents() == true then
  if internet == true then
    print("Update? yes/no")
    askUpdate = io.read()
    if askUpdate == "yes" then
      update()
    end
  end
  dofile("stargate/control.lua")
end
