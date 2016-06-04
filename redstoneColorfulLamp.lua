local component = require("component")
local event = require("event")
local m = component.modem
local run = true
local port = 1

function rot()
  print("rot")
  Farbe(31744)
end

function gelb()
  print("gelb")
  Farbe(32736)
end

function orange()
  print("orange")
  Farbe(32256)
end

function gruen()
  print("grün")
  Farbe(992)
end

function weiss()
  print("weiß")
  Farbe(32767)
end

function schwarz()
  print("schwarz")
  Farbe(0)
end

function Farbe(eingabe)
  for k in component.list("colorful_lamp") do
    component.proxy(k).setLampColor(eingabe)
  end
end

function redstone()
  if iris == true then
    rot()
  elseif verbunden == false then
    weiss()
    idc = false
    eingehend = false
    notIdle = false
  elseif idc == true then
    gruen()
  elseif eingehend == true then
    orange()
  elseif verbunden == true then
    gruen()
  elseif notIdle == true then
    gelb()
  else
    weiss()
  end
end

function dekodieren()
  if farbe == "notIdle" then
    notIdle = zustand
  elseif farbe == "eingehend" then
    eingehend = zustand
  elseif farbe == "iris" then
    iris = zustand
  elseif farbe == "idc" then
    idc = zustand
  elseif farbe == "verbunden" then
    verbunden = zustand
  end
end

m.open(port)

while run do
  redstone()
  _, _, _, _, _, farbe, zustand = event.pull("modem_message")
  dekodieren()
end
