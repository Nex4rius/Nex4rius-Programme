-- pastebin run -f 63v6mQtK
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function standby()
  local component   = require("component")
  if component.isAvailable("screen") and component.isAvailable("gpu") then
    local computer  = require("computer")
    local standby   = 0.90
    local display   = 0.75
    local wartezeit = 5
    local screen    = component.getPrimary("screen")
    local gpu       = component.getPrimary("gpu")
    local x, y      = gpu.getResolution()
    local hinten    = gpu.getBackground()
    local vorne     = gpu.getForeground()
    
    local function energie()
      return computer.energy() / computer.maxEnergy()
    end
    
    while energie() < standby do
      if energie() < display and screen then
        screen.turnOff()
        os.sleep(wartezeit * 2)
      else
        screen.turnOn()
        gpu.setBackground(0x000000)
        gpu.setForeground(0xFFFFFF)
        gpu.setResolution(1, 21)
        require("term").clear()
        gpu.set(1, 1, string.format("Standby Energie: %.f%%", energie() * 100))
        os.sleep(wartezeit)
      end
    end
    
    screen.turnOn()
    gpu.setResolution(x, y)
    gpu.setBackground(hinten)
    gpu.setForeground(vorne)
    os.sleep(0.1)
    
    return true
  else
    return false
  end
end

return standby
