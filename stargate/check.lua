version = "1.4.5"
component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")
gpu = component.getPrimary("gpu")

function checkComponents()
  print("Checking Components\n")
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
    print("- Stargate             ok\n")
    sg = component.getPrimary("stargate")
    return true
  else
    print("- Stargate             Missing\n")
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
  os.execute("reboot")
end

function checkServerVersion()
  os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/version.lua' version.lua")
  dofile("version.lua")
end

if checkComponents() == true then
  print(checkServerVersion())
  if internet == true then
--    if serverVersion == nil then
--      serverVersion = "Unavailable"
--    end
    if version == serverVersion then
    elseif install == nil and not serverVersion == nil then
      print("\nCurrect Version:       " .. version .. "\nAvailable Version:     " .. serverVersion .. "\n\nUpdate? yes/no\n")
      askUpdate = io.read()
      print("\nUpdate: " .. askUpdate)
      if askUpdate == "yes" or askUpdate == "ye" or askUpdate == "y" then
        print("")
        update()
      end
    end
--    os.execute("del version.lua")
  end
  print("\nLoading...")
  dofile("stargate/control.lua")
end
