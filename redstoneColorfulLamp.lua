local component = require("component")
local r = component.getPrimary("redstone")
local m = component.modem
local Richtung = 1
local run = true

function rot()
  print("rot")
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 9, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gelb()
  print("gelb")
  for i = 14, 4, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function orange()
  print("orange")
  for i = 9, 14 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 8, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gruen()
  print("grün")
  for i = 9, 5, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function weiss()
  print("weiß")
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function schwarz()
  print("schwarz")
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function redstone()
  if r.getBundledInput(AusgangRichtung, 15) > 0 then
    run = false
    schwarz()
    return
  elseif nachricht == 4 then
    rot()
  elseif nachricht == 15 then
    gruen()
  elseif nachricht == 14 then
    orange()
  elseif nachricht == 13 then
    gruen()
  elseif nachricht == 0 then
    if nachricht == 14 then
      gruen()
    else
      gelb()
    end
  else
    weiss()
  end
end

while run do
  redstone()
  local _, _, _, _, _, nachricht = event.pull("modem_message")
end
