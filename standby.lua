-- pastebin run -f 63v6mQtK
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function standby(arg)
  local component = require("component")
  local computer = require("computer")
  local term = require("term")
  local standby = 0.90
  local display = 0.75
  local wartezeit = 20
  local screen, gpu
  local x, y
  
  if component.isAvailable("screen") then
    screen = component.getPrimary("screen")
  end
  if component.isAvailable("gpu") then
    gpu = component.getPrimary("gpu")
    x, y = gpu.getResolution()
  end
  if type(arg) == "table" then
    if type(arg.standby) == "number" then
      standby = arg.standby
    end
    if type(arg.display) == "number" then
      display = arg.display
    end
    if type(arg.wait) == "number" then
      wartezeit = arg.wait
    end
  end
  local function energie()
    return computer.energy() / computer.maxEnergy()
  end
  if gpu and energie() < standby then
    gpu.setResolution(1, 21)
  end
  while energie() < standby do
    term.clear()
    print(string.format("Standby Energie: %.f%%", energie() * 100))
    if energie() < display and screen then
      screen.turnOff()
    end
    os.sleep(wartezeit)
  end
  if screen then
    screen.turnOn()
  end
  if gpu then
    gpu.setResolution(x, y)
  end
  return true
end

return standby
