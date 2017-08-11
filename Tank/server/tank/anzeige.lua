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
local debug           = false
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
    local i = 0
    for screenid in component.list("screen") do
      i = i + 1
    end
    for screenid in component.list("screen") do
      if i > 1 then
        gpu.bind(screenid, false)
      end
      anzeigen(verarbeiten(tank), screenid)
    end
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
    for screenid in component.list("screen") do
      gpu.bind(screenid, false)
      gpu.setResolution(21, 1)
      os.sleep(0.1)
      term.clear()
      gpu.set(1, 1, "Keine Daten vorhanden")
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
      if type(tank[i].inhalt) == "table" then
        for j in pairs(tank[i].inhalt) do
          tanknr = tanknr + 1
          hinzu(tank[i].inhalt[j].name, tank[i].inhalt[j].label, tank[i].inhalt[j].menge, tank[i].inhalt[j].maxmenge)
        end
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

function anzeigen(tankneu, screenid)
  local klein = false
  local screenid = screenid or gpu.getScreen()
  local _, hoch = component.proxy(screenid).getAspectRatio()
  if hoch <= 2 then
    klein = true
  end
  local x = 1
  local y = 1
  local leer = true
  local maxanzahl = 0
  for i in pairs(tankneu) do
    maxanzahl = maxanzahl + 1
  end
  local a, b = gpu.getResolution()
  if maxanzahl <= 16 and maxanzahl ~= 0 then
    if klein then
      if a ~= 160 or b ~= maxanzahl then
        gpu.setResolution(160, maxanzahl)
      end
    else
      if a ~= 160 or b ~= maxanzahl * 3 then
        gpu.setResolution(160, maxanzahl * 3)
      end
    end
  else
    if klein then
      if a ~= 160 or b ~= 16 then
      gpu.setResolution(160, 16)
      end
    else
      if a ~= 160 or b ~= 48 then
      gpu.setResolution(160, 48)
      end
    end
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
        if klein then
          y = 1 + (64 - maxanzahl)
        else
          y = 1 + 3 * (64 - maxanzahl)
        end
        breite = 40
      elseif maxanzahl > 32 and anzahl > 32 then
        x = 121
        if klein then
          y = 1 + (48 - maxanzahl)
        else
          y = 1 + 3 * (48 - maxanzahl)
        end
        breite = 40
      else
        x = 81
        if klein then
          y = 1 + (32 - maxanzahl)
        else
          y = 1 + 3 * (32 - maxanzahl)
        end
      end
      if y < 1 then
        y = 1
      end
    end
    local name = string.gsub(tankneu[i].name, "%p", "")
    local label = zeichenErsetzen(string.gsub(tankneu[i].label, "%p", ""))
    local menge = tankneu[i].menge
    local maxmenge = tankneu[i].maxmenge
    local prozent = string.format("%.1f%%", menge / maxmenge * 100)
    if label == "fluidhelium3" then
      label = "Helium-3"
    end
    zeigeHier(x, y, label, name, menge, maxmenge, string.format("%s%s", string.rep(" ", 8 - string.len(prozent)), prozent), links, rechts, breite, string.sub(string.format(" %s", label), 1, 31), klein, maxanzahl)
    leer = false
    if klein then
      y = y + 1
    else
      y = y + 3
    end
  end
  Farben(0xFFFFFF, 0x000000)
  for i = anzahl, 33 do
    gpu.set(x, y    , string.rep(" ", 80))
    if not klein then
      gpu.set(x, y + 1, string.rep(" ", 80))
      gpu.set(x, y + 2, string.rep(" ", 80))
    end
    if klein then
      y = y + 1
    else
      y = y + 3
    end
  end
  if leer then
    keineDaten()
  end
end

function zeichenErsetzen(...)
  return string.gsub(..., "%a+", function (str) return ersetzen[str] end)
end

function zeigeHier(x, y, label, name, menge, maxmenge, prozent, links, rechts, breite, nachricht, klein, maxanzahl)
  if farben[name] == nil and debug then
    nachricht = string.format("%s  %s  >>report this liquid<<<  %smb / %smb  %s", name, label, menge, maxmenge, prozent)
    nachricht = split(nachricht .. string.rep(" ", breite - string.len(nachricht)))
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
  if farben[name] == nil then
   name = "unbekannt"
  end
  Farben(farben[name][1], farben[name][2])
  local ende = 0
  for i = 1, math.ceil(breite * menge / maxmenge) do
    if klein and maxanzahl > 16 then
      gpu.set(x, y, string.format("%s", nachricht[i]), true)
    else
      gpu.set(x, y, string.format(" %s ", nachricht[i]), true)
    end
    x = x + 1
    ende = i
  end
  Farben(farben[name][3], farben[name][4])
  for i = 1, breite - math.ceil(breite * menge / maxmenge) do
    if klein and maxanzahl > 16  then
      gpu.set(x, y, string.format("%s", nachricht[i + ende]), true)
    else
      gpu.set(x, y, string.format(" %s ", nachricht[i + ende]), true)
    end
    x = x + 1
  end
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
  Farben(0xFFFFFF, 0x000000)
  gpu.setResolution(gpu.maxResolution())
  os.sleep(0.1)
  term.clear()
end

function main()
  gpu.setBackground(0x000000)
  term.setCursor(1, 50)
  m.open(port)
  for screenid in component.list("screen") do
    gpu.bind(screenid, false)
    gpu.setResolution(15, 1)
    os.sleep(0.1)
    term.clear()
    gpu.set(1, 1, "Warte auf Daten")
  end
  m.broadcast(port + 1, "update", version)
  while true do
    if not pcall(update) then
      os.sleep(5)
    end
    standby()
  end
end

if not pcall(main) then
  print("Ausschalten")
  beenden()
end
