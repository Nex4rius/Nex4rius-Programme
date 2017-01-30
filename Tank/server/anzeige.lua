local component = require("component")
local c = require("computer")
local gpu = component.getPrimary("gpu")
local event = require("event")
local term = require("term")
local m = component.modem
local farben = loadfile("/farben.lua")()
local port = 70
local tank = {}
local tankneu

function update()
  local hier, _, id, _, _, nachricht = event.pull(60, "modem_message")
  local dazu = true
  local ende = 0
  if hier then
    for i in pairs(tank) do
      if type(tank[i]) == "table" then
        if tank[i].id == id then
          tank[i].zeit = c.uptime()
          tank[i].inhalt = require("serialization").unserialize(nachricht)
          dazu = false
        end
      end
      ende = i
    end
    if dazu then
      ende = ende + 1
      tank[ende] = {}
      tank[ende].id = id
      tank[ende].zeit = c.uptime()
      tank[ende].inhalt = require("serialization").unserialize(nachricht)
    end
    anzeigen(verarbeiten(tank))
  else
    m.broadcast(port, "update")
    print("Keine Daten vorhanden")
  end
  for i in pairs(tank) do
    if c.uptime() - tank[i].zeit > 45 then
      tank[i] = nil
    end
  end
end

function hinzu(name, menge, maxmenge)
  local weiter = true
  if name ~= "nil" then
    for i in pairs(tankneu) do
      if tankneu[i].name == name then
        tankneu[i].menge = tankneu[i].menge + menge
        tankneu[i].maxmenge = tankneu[i].maxmenge + maxmenge
        weiter = false
      end
    end
    if weiter then
      tankneu[tanknr] = {}
      tankneu[tanknr].name = name
      tankneu[tanknr].menge = menge
      tankneu[tanknr].maxmenge = maxmenge
    end
  end
end

function verarbeiten(tank)
  tankneu = {}
  tanknr = 0
  for i in pairs(tank) do
    if type(tank[i]) == "table" then
      for j in pairs(tank[i].inhalt) do
        tanknr = tanknr + 1
        hinzu(tank[i].inhalt[j].name, tank[i].inhalt[j].menge, tank[i].inhalt[j].maxmenge)
      end
    end
  end
  return tankneu
end

function anzeigen(tankneu)
  local x = 1
  local y = 1
  local leer = true
  for i in pairs(tankneu) do
    local name = tankneu[i].name
    local menge = tankneu[i].menge
    local maxmenge = tankneu[i].maxmenge
    local prozent = menge / maxmenge * 100
    zeigeHier(x, y, name, menge, maxmenge, prozent)
    y = y + 3
    leer = false
  end
  if leer then
    print("Keine Daten vorhanden")
  end
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
end

function zeigeHier(x, y, name, menge, maxmenge, prozent)
  local nachricht = string.format("%s %smb/%smb %.1f%%", name, menge, maxmenge, prozent)
  local laenge = (80 - string.len(nachricht)) / 2
  nachricht = split(string.format("%s%s%s ", string.rep(" ", laenge), nachricht, string.rep(" ", laenge)))
  if farben[name] == nil then
    name = "unbekannt"
  end
  gpu.setBackground(0xFF0000)
  gpu.set(81, 1, "                                                             ", true)
  gpu.setBackground(farben[name].hinterAN)
  gpu.setForeground(farben[name].schriftAN)
  local ende = 0
  for i = 1, math.floor(80 * menge / maxmenge) do
    gpu.set(x, y, string.format(" %s ", nachricht[i]), true)
    x = x + 1
    ende = i
  end
  gpu.setBackground(farben[name].hinterAUS)
  gpu.setForeground(farben[name].schriftAUS)
  local a = math.floor(80 * menge / maxmenge)
  for i = 1, 80 - a do
    gpu.set(x, y, string.format(" %s ", nachricht[i + ende]), true)
    x = x + 1
  end
end

function split(a)
  local output = {}
  for i = 1, string.len(a) do
    output[i] = string.sub(a, i, i)
  end
  return output
end

function main()
  term.clear()
  term.setCursor(1, 50)
  m.open(port)
  m.broadcast(port, "update")
  print("Warte auf Daten")
  while true do
    update()
  end
end

main()

gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.setResolution(gpu.maxResoltution())
