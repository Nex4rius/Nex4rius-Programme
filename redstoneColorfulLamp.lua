component = require("component")
event = require("event")
r = component.getPrimary("redstone")
AusgangRichtung = 1
EingangRichtung = 0

a = true

function rot()
  for i = 14, 10, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 9, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function gelb()
  for i = 14, 4, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function orange()
  for i = 9, 14 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
  for i = 8, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

function gruen()
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
  for i = 14, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 255)
  end
end

function schwarz()
  for i = 14, 0, -1 do
    r.setBundledOutput(AusgangRichtung, i, 0)
  end
end

--getBundledInput(EingangRichtung, 0)  --weiß: Status nicht Inaktiv
--getBundledInput(EingangRichtung, 14) --rot: eingehende Verbindung
--getBundledInput(EingangRichtung, 4)  --gelb: Iris geschlossen
--getBundledInput(EingangRichtung, 15) --schwarz: IDC akzeptiert
--getBundledInput(EingangRichtung, 13) --grün: verbunden

function redstone()
  if getBundledInput(EingangRichtung, 15) > 0 then
    a = false
  elseif getBundledInput(EingangRichtung, 4) > 0 then
    rot()
  elseif getBundledInput(EingangRichtung, 15) > 0 then
    gruen()
  elseif getBundledInput(EingangRichtung, 14) > 0 then
    orange()
  elseif getBundledInput(EingangRichtung, 13) > 0 then
    gruen()
  elseif getBundledInput(EingangRichtung, 0) > 0 then
    gelb()
  else
    weiss()
  end
end

while a do
  redstone()
  event.pull(300)
end
