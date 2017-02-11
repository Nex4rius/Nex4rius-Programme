-- pastebin run -f 63v6mQtK
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function standby(text)
  local component = require("component")
  local computer  = require("computer")
  local standby   = 0.90
  local display   = 0.75
  local wartezeit = 5
  
  if component.isAvailable("screen") and component.isAvailable("gpu") then
    local screen = component.getPrimary("screen")
    local gpu = component.getPrimary("gpu")
    
    local function energie()
      return computer.energy() / computer.maxEnergy()
    end
    
    while energie() < standby do
      require("term").clear()
      if energie() < display and screen then
        screen.turnOff()
        os.sleep(wartezeit * 6)
      else
        screen.turnOn()
        if text then
          gpu.set(1, 1, string.format("Standby Energie: %.f%%", energie() * 100))
        end
        os.sleep(wartezeit)
      end
    end
    
    screen.turnOn()
    
    return true
  end
end

return standby
