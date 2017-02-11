-- pastebin run -f 63v6mQtK
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function standby(arg)
  local component = require("component")
  local computer = require("computer")
  local standby = 0.75
  local display = 0.50
  local wartezeit = 30
  local screen
  
  if component.isAvailable("screen") then
    screen = component.getPrimary("screen")
  end
  if type(arg) == "table" then
    if type(arg.standby) == "number" then
      standby = arg.standby
    end
    if type(arg.display) == "number" then
      display = arg.display
    end
    if type(arg.wartezeit) == "number" then
      wartezeit = arg.wartezeit
    end
  end
  local function energie()
    return computer.energy() / computer.maxEnergy()
  end
  while energie() < standby do
    if energie() < display and screen then
      print("jetzt aus")
      --screen.turnOff()
    end
    os.sleep(wartezeit)
  end
  if screen then
    print("jetzt an")
    screen.turnOn()
  end
  return true
end

return standby
