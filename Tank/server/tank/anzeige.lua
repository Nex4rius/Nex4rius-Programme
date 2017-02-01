local component = require("component")
local c = require("computer")
local gpu = component.getPrimary("gpu")
local event = require("event")
local term = require("term")
local m = component.modem
local farben = loadfile("/tank/farben.lua")()
local port = 70
local tank = {}
local laeuft = true
local tankneu

function update()
  local hier, _, id, _, _, nachricht = event.pull(120, "modem_message")
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
    gpu.setResolution(gpu.maxResolution())
    term.clear()
    gpu.set(1, 50, "Keine Daten vorhanden")
  end
  for i in pairs(tank) do
    if c.uptime() - tank[i].zeit > 90 then
      tank[i] = nil
    end
  end
end

function hinzu(name, label, menge, maxmenge)
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
      tankneu[tanknr].label = label
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
        hinzu(tank[i].inhalt[j].name, tank[i].inhalt[j].label, tank[i].inhalt[j].menge, tank[i].inhalt[j].maxmenge)
      end
    end
  end
  return tankneu
end

function anzeigen(tankneu)
  local x = 1
  local y = 1
  local leer = true
  if #tankneu ~= 0 and #tankneu < 17 then
    gpu.setResolution(80, #tankneu * 3)
  else
    gpu.setResolution(160, 48)
  end
  os.sleep(1)
  for i in pairs(tankneu) do
    if i == 17 then
      x = 81
      y = 1
    end
    local name = tankneu[i].name
    local label = tankneu[i].label
    local menge = tankneu[i].menge
    local maxmenge = tankneu[i].maxmenge
    local prozent = menge / maxmenge * 100
    zeigeHier(x, y, label, name, menge, maxmenge, prozent)
    y = y + 3
    leer = false
  end
  if leer then
    gpu.setResolution(gpu.maxResolution())
    term.clear()
    gpu.set(1, 50, "Keine Daten vorhanden")
  end
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
end

function zeigeHier(x, y, label, name, menge, maxmenge, prozent)
  local nachricht = string.format("%s     %smb/%smb     %.1f%%", label, menge, maxmenge, prozent)
  local laenge = (80 - string.len(nachricht)) / 2
  nachricht = split(string.format("%s%s%s ", string.rep(" ", laenge), nachricht, string.rep(" ", laenge)))
  name = string.gsub(string.gsub(name, "-", "_"), "%.", "_")
  if farben[name] == nil then
    name = "unbekannt"
  end
  gpu.setForeground(farben[name][1])
  gpu.setBackground(farben[name][2])
  local ende = 0
  for i = 1, math.floor(80 * menge / maxmenge) do
    gpu.set(x, y, string.format(" %s ", nachricht[i]), true)
    x = x + 1
    ende = i
  end
  gpu.setForeground(farben[name][3])
  gpu.setBackground(farben[name][4])
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

function beenden()
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  gpu.setResolution(gpu.maxResoltution())
end

function main()
  gpu.setBackground(0x000000)
  term.clear()
  term.setCursor(1, 50)
  m.open(port)
  m.broadcast(port, "update")
  gpu.set(1, 50, "Warte auf Daten")
  while laeuft do
    update()
  end
  beenden()
end

main()
