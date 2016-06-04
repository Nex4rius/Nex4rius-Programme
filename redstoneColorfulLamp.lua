component = require("component")
event = require("event")
r = component.getPrimary("redstone")
AusgangRichtung = 1
EingangRichtung = 0

run = true

function rot()
  print("rot")
  for i = 14, 10, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 9, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function gelb()
  print("gelb")
  for i = 14, 4, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function orange()
  print("orange")
  for i = 9, 14 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 8, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function gruen()
  print("grün")
  for i = 9, 5, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
  for i = 14, 10, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function weiss()
  print("weiß")
  for i = 14, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
end

function schwarz()
  print("schwarz")
  for i = 14, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

--r.getBundledInput(EingangRichtung, 0)  --weiß: Status nicht Inaktiv
--r.getBundledInput(EingangRichtung, 14) --rot: eingehende Verbindung
--r.getBundledInput(EingangRichtung, 4)  --gelb: Iris geschlossen
--r.getBundledInput(EingangRichtung, 15) --schwarz: IDC akzeptiert
--r.getBundledInput(EingangRichtung, 13) --grün: verbunden

function redstone()
  if r.getBundledInput(AusgangRichtung, 15) > 0 then
    run = false
    schwarz()
    return
  elseif r.getBundledInput(EingangRichtung, 4) > 0 then
    rot()
  elseif r.getBundledInput(EingangRichtung, 15) > 0 then
    gruen()
  elseif r.getBundledInput(EingangRichtung, 14) > 0 then
    orange()
  elseif r.getBundledInput(EingangRichtung, 13) > 0 then
    gruen()
  elseif r.getBundledInput(EingangRichtung, 0) > 0 then
    if r.getBundledInput(EingangRichtung, 14) == 0 then
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

  print(r.getBundledInput(EingangRichtung, 0) ) --weiß: Status nicht Inaktiv
  print(r.getBundledInput(EingangRichtung, 14)) --rot: eingehende Verbindung
  print(r.getBundledInput(EingangRichtung, 4) ) --gelb: Iris geschlossen
  print(r.getBundledInput(EingangRichtung, 15)) --schwarz: IDC akzeptiert
  print(r.getBundledInput(EingangRichtung, 13)) --grün: verbunden
  a, b, c = event.pull("redstone_changed")
end
