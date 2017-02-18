-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

local component       = require("component")
local fs              = require("filesystem")
local c               = require("computer")
local event           = require("event")
local term            = require("term")

local farben          = loadfile("/tank/farben.lua")()
local ersetzen        = loadfile("/tank/ersetzen.lua")()

local gpu             = component.getPrimary("gpu")
local m               = component.modem

local version, tankneu, energie

local port            = 70
local tank            = {}
local laeuft          = true
local Wartezeit       = 150
local letzteNachricht = c.uptime()
local standby         = function() end

if fs.exists("/bin/standby.lua") then
  standby             = require("standby")
end

if fs.exists("/tank/version.txt") then
    local f = io.open ("/tank/version.txt", "r")
    version = f:read()
    f:close()
  else
    version = "<FEHLER>"
end

function update()
  local dazu = true
  local ende = 0
  local hier, _, id, _, _, nachricht = event.pull(Wartezeit, "modem_message")
  if hier then
    term.clear() -- debug
    letzteNachricht = c.uptime()
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
    keineDaten()
  end
  for i in pairs(tank) do
    if c.uptime() - tank[i].zeit > Wartezeit * 2 then
      tank[i] = nil
    end
  end
end

function keineDaten()
  m.broadcast(port + 1, "update", version)
  if c.uptime() - letzteNachricht > Wartezeit then
    gpu.setResolution(gpu.maxResolution())
    gpu.fill(1, 1, 160, 80, " ")
    gpu.set(1, 50, "Keine Daten vorhanden")
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

function spairs(t, order)
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end
  if order then
    table.sort(keys, function(a,b) return order(t, a, b) end)
  else
    table.sort(keys)
  end
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

function anzeigen(tankneu)
  local x = 1
  local y = 1
  local leer = true
  local maxanzahl = 0
  for i in pairs(tankneu) do
    maxanzahl = maxanzahl + 1
  end
  if maxanzahl <= 16 and maxanzahl ~= 0 then
    gpu.setResolution(160, maxanzahl * 3)
  else
    gpu.setResolution(160, 48)
  end
  os.sleep(0.1)
  local anzahl = 0
  for i in spairs(tankneu, function(t,a,b) return tonumber(t[b].menge) < tonumber(t[a].menge) end) do
    anzahl = anzahl + 1
    local links, rechts, breite = -15, -25, 40
    if (32 - maxanzahl) >= anzahl and maxanzahl < 32 then
      links, rechts = 40, 40
      breite = 160
    elseif (64 - maxanzahl) >= anzahl and maxanzahl > 16 then
      links, rechts = 0, 0
      breite = 80
    end
    if anzahl == 17 or anzahl == 33 or anzahl == 49 then
      if maxanzahl > 48 and anzahl > 48 then
        x = 41
        y = 1 + 3 * (64 - maxanzahl)
        breite = 40
      elseif maxanzahl > 32 and anzahl > 32 then
        x = 121
        y = 1 + 3 * (48 - maxanzahl)
        breite = 40
      elseif maxanzahl > 32 and anzahl == 33 then
        x = 81
        y = 1
      else
        x = 81
        y = 1 + 3 * (32 - maxanzahl)
      end
    end
    local name = string.gsub(tankneu[i].name, "%p", "")
    local label = zeichenErsetzen(string.gsub(tankneu[i].label, "%p", ""))
    local menge = tankneu[i].menge
    local maxmenge = tankneu[i].maxmenge
    local prozent = string.format("%.1f%%", menge / maxmenge * 100)
    zeigeHier(x, y, label, name, menge, maxmenge, string.format("%s%s", string.rep(" ", 8 - string.len(prozent)), prozent), links, rechts, breite, anzahl, string.sub(string.format(" %s", label), 1, 28))
    leer = false
    y = y + 3
    os.sleep(0.1) -- debug
  end
  Farben(0xFFFFFF, 0x000000)
  for i = anzahl, 33 do
    gpu.set(x, y    , string.rep(" ", 80))
    gpu.set(x, y + 1, string.rep(" ", 80))
    gpu.set(x, y + 2, string.rep(" ", 80))
    y = y + 3
  end
  if leer then
    keineDaten()
  end
end

function zeichenErsetzen(...)
  return string.gsub(..., "%a+", function (str) return ersetzen[str] end)
end

function zeigeHier(x, y, label, name, menge, maxmenge, prozent, links, rechts, breite, anzahl, nachricht)
  if label == "fluidhelium3" then
    label = "Helium-3"
  end
  if farben[name] == nil then
    nachricht = string.format("%s  %s  >>report this liquid<<<  %smb / %smb  %s", name, label, menge, maxmenge, anzahl, prozent)
    nachricht = split(nachricht .. string.rep(" ", breite - string.len(nachricht)))
    name = "unbekannt"
  else
    local ausgabe = {}
    if breite == 40 then
      table.insert(ausgabe, string.sub(nachricht, 1, 37 - string.len(menge) - string.len(prozent)))
      table.insert(ausgabe, string.rep(" ", 37 - string.len(nachricht) - string.len(menge) - string.len(prozent)))
      table.insert(ausgabe, menge)
      table.insert(ausgabe, "mb")
      table.insert(ausgabe, prozent)
      table.insert(ausgabe, " ")
    else
      table.insert(ausgabe, string.sub(nachricht, 1, 25))
      table.insert(ausgabe, string.rep(" ", links + 38 - string.len(nachricht) - string.len(menge)))
      table.insert(ausgabe, menge)
      table.insert(ausgabe, "mb")
      table.insert(ausgabe, " / ")
      table.insert(ausgabe, maxmenge)
      table.insert(ausgabe, "mb")
      table.insert(ausgabe, string.rep(" ", rechts + 26 - string.len(maxmenge)))
      table.insert(ausgabe, prozent)
      table.insert(ausgabe, " ")
    end
    nachricht = split(table.concat(ausgabe))
  end
  Farben(farben[name][1], farben[name][2])
  local ende = 0
  for i = 1, math.floor(breite * menge / maxmenge) do
    gpu.set(x, y, string.format(" %s ", nachricht[i]), true)
    x = x + 1
    ende = i
  end
  Farben(farben[name][3], farben[name][4])
  for i = 1, breite - math.floor(breite * menge / maxmenge) do
    gpu.set(x, y, string.format(" %s ", nachricht[i + ende]), true)
    x = x + 1
  end
  gpu.set(x - breite, y + 2, tostring(anzahl))
  gpu.set(1, 1, string.format("%s   x = %s   y = %s", tostring(anzahl), tostring(x), tostring(y))
end

function Farben(vorne, hinten)
  if type(vorne) == "number" then
    gpu.setForeground(vorne)
  else
    gpu.setForeground(0xFFFFFF)
  end
  if type(hinten) == "number" then
    gpu.setBackground(hinten)
  else
    gpu.setBackground(0x333333)
  end
end

function split(...)
  local output = {}
  for i = 1, string.len(...) do
    output[i] = string.sub(..., i, i)
  end
  return output
end

function beenden()
  laeuft = false
  Farben(0xFFFFFF, 0x000000)
  gpu.setResolution(gpu.maxResoltution())
  os.sleep(0.1)
  term.clear()
end

function main()
  gpu.setBackground(0x000000)
  term.setCursor(1, 50)
  m.open(port)
  gpu.setResolution(gpu.maxResolution())
  gpu.fill(1, 1, 160, 80, " ")
  gpu.set(1, 50, "Warte auf Daten")
  m.broadcast(port + 1, "update", version)
  while laeuft do
    update()
    standby()
  end
  beenden() -- bisher nie
end

main()
