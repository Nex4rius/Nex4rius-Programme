-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

os.sleep(2)

local io              = io
local os              = os
local table           = table
local string          = string
local print           = print
local pcall           = pcall
local require         = require
local loadfile        = loadfile

local component       = require("component")
local fs              = require("filesystem")
local serialization   = require("serialization")
local c               = require("computer")
local event           = require("event")
local term            = require("term")

local farben          = loadfile("/tank/farben.lua")()
local ersetzen        = loadfile("/tank/ersetzen.lua")()
local wget            = loadfile("/bin/wget.lua")

local gpu             = component.getPrimary("gpu")
local m               = component.getPrimary("modem")

local version, tankneu, energie, Updatetimer

local port            = 918
local arg             = string.lower(tostring(...))
local dateiliste      = {"/autorun.lua", "/tank/auslesen.lua", "/tank/version.txt"}
local tank            = {}
local f               = {}
local o               = {}
local timer           = {}
local Sensorliste     = {}
local laeuft          = true
local debug           = false
local Sendeleistung   = math.huge
local Wartezeit       = 150
local letzteNachricht = c.uptime()
local Zeit            = 60

if fs.exists("/tank/version.txt") then
  local d = io.open("/tank/version.txt", "r")
  version = d:read()
  d:close()
else
  version = "<FEHLER>"
end

if arg == "n" or arg == "nein" or arg == "no" then
  arg = nil
else
  arg = true
end

function f.tank(hier, id, nachricht)
  local dazu = true
  local ende = 0
  if hier then
    letzteNachricht = c.uptime()
    for i = 1, #tank do
      if type(tank[i]) == "table" then
        if tank[i].id == id then
          tank[i].zeit = c.uptime()
          tank[i].inhalt = serialization.unserialize(nachricht)
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
      tank[ende].inhalt = serialization.unserialize(nachricht)
    end
  else
    f.keineDaten()
  end
  for i = 1, #tank do
    if c.uptime() - tank[i].zeit > Wartezeit * 2 then
      tank[i] = nil
    end
  end
  f.verarbeiten(tank)
end

function f.verarbeiten(tank)
  tankneu = {}
  tanknr = 0
  for i = 1, #tank do
    if type(tank[i]) == "table" then
      if type(tank[i].inhalt) == "table" then
        local start, dazu = 1, false
        if tank[i].inhalt[1].name == "Tankname" and tank[i].inhalt[1].label == "false" then
          start = 2
          dazu = true
        end
        for j = start, #tank[i].inhalt do
          tanknr = tanknr + 1
          f.hinzu(tanknr, tank[i].inhalt[j].name, tank[i].inhalt[j].label, tank[i].inhalt[j].menge, tank[i].inhalt[j].maxmenge, dazu, true)
        end
      end
    end
  end
end

function f.hinzu(tanknr, name, label, menge, maxmenge, dazu, weiter)
  if name ~= "nil" then
    if dazu then
      for i = 1, #tankneu do
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
    else
      tankneu[tanknr] = {}
      tankneu[tanknr].name = name
      tankneu[tanknr].label = label
      tankneu[tanknr].menge = menge
      tankneu[tanknr].maxmenge = maxmenge
    end
  else
    print(name)
    io.read()
  end
end

local function spairs(t, order)
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

function f.anzeigen()
  for screenid in component.list("screen") do
    gpu.bind(screenid, false)
    local klein = false
    local _, hoch = component.proxy(screenid).getAspectRatio()
    if hoch <= 2 then
      klein = true
    end
    local x = 1
    local y = 1
    local leer = true
    local maxanzahl = #tankneu
    local a, b = gpu.getResolution()
    if maxanzahl <= 16 and maxanzahl ~= 0 then
      if klein and maxanzahl > 5 then
        if a ~= 160 or b ~= maxanzahl then
          gpu.setResolution(160, maxanzahl)
        end
      else
        if a ~= 160 or b ~= maxanzahl * 3 then
          gpu.setResolution(160, maxanzahl * 3)
        end
      end
    else
      if klein and maxanzahl > 5 then
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
    --for i in spairs(tankneu, function(t,a,b) return tonumber(t[b].menge) < tonumber(t[a].menge) end) do
    for i = 1, #tankneu do
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
          if klein and maxanzahl > 5 then
            y = 1 + (64 - maxanzahl)
          else
            y = 1 + 3 * (64 - maxanzahl)
          end
          breite = 40
        elseif maxanzahl > 32 and anzahl > 32 then
          x = 121
          if klein and maxanzahl > 5 then
            y = 1 + (48 - maxanzahl)
          else
            y = 1 + 3 * (48 - maxanzahl)
          end
          breite = 40
        else
          x = 81
          if klein and maxanzahl > 5 then
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
      local label = f.zeichenErsetzen(string.gsub(tankneu[i].label, "%p", ""))
      local menge = tankneu[i].menge
      local maxmenge = tankneu[i].maxmenge
      local prozent = string.format("%.1f%%", menge / maxmenge * 100)
      if label == "fluidhelium3" then
        label = "Helium-3"
      end
      f.zeigeHier(x, y, label, name, menge, maxmenge, string.format("%s%s", string.rep(" ", 8 - string.len(prozent)), prozent), links, rechts, breite, string.sub(string.format(" %s", label), 1, 31), klein, maxanzahl)
      leer = false
      if klein and maxanzahl > 5 then
        y = y + 1
      else
        y = y + 3
      end
    end
    f.Farben(0xFFFFFF, 0x000000)
    for i = anzahl, 33 do
      gpu.set(x, y , string.rep(" ", 80))
      if not (klein and maxanzahl > 5) then
        gpu.set(x, y + 1, string.rep(" ", 80))
        gpu.set(x, y + 2, string.rep(" ", 80))
      end
      if klein and maxanzahl > 5 then
        y = y + 1
      else
        y = y + 3
      end
    end
    if leer then
      keineDaten()
    end
  end
end

function f.zeichenErsetzen(...)
  return string.gsub(..., "%a+", function (str) return ersetzen[str] end)
end

function f.zeigeHier(x, y, label, name, menge, maxmenge, prozent, links, rechts, breite, nachricht, klein, maxanzahl)
  if farben[name] == nil and debug then
    nachricht = string.format("%s  %s  >>report this liquid<<<  %smb / %smb  %s", name, label, menge, maxmenge, prozent)
    nachricht = split(nachricht .. string.rep(" ", breite - string.len(nachricht)))
  elseif name == "Tankname" then
    local ausgabe = {}
    if klein and maxanzahl > 5 then
      table.insert(ausgabe, "━" .. string.rep("━", math.floor((breite - string.len(label)) / 2) - 2) .. " ")
      table.insert(ausgabe, string.sub(label, 1, breite - 4))
      table.insert(ausgabe, " " .. string.rep("━", math.ceil((breite - string.len(label)) / 2) - 2) .. "━")
    else
      table.insert(ausgabe, " ┃ " .. string.rep(" ", math.floor((breite - string.len(label)) / 2) - 3))
      table.insert(ausgabe, string.sub(label, 1, breite - 6))
      table.insert(ausgabe, string.rep(" ", math.ceil((breite - string.len(label)) / 2) - 3) .. " ┃ ")
    end
    nachricht = split(table.concat(ausgabe))
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
  local oben = " ┏" .. string.rep("━", breite - 4) .. "┓ "
  local unten = " ┗" .. string.rep("━", breite - 4) .. "┛ "
  local grenze = math.ceil(breite * menge / maxmenge)
          gpu.set(1, 1, "b " .. tostring(tank[i].inhalt[j].name) .. "   " .. tostring(tank[i].inhalt[j].label) .. "                   ")
          os.sleep(2)
  f.Farben(farben[name][1], farben[name][2])
  if klein and maxanzahl > 5 then
    if name == "Tankname" then
      gpu.set(x, y, table.concat(nachricht))
    else
      gpu.set(x, y, table.concat(nachricht, nil, 1, grenze))
    end
  else
    if name == "Tankname" then
      gpu.set(x, y, oben)
      gpu.set(x, y + 1, table.concat(nachricht))
      gpu.set(x, y + 2, unten)
    else
      gpu.fill(x, y, grenze, 1, " ")
      gpu.set(x, y + 1, table.concat(nachricht, nil, 1, grenze))
      gpu.fill(x, y + 2, grenze, 1, " ")
    end
  end
  x = x + grenze
  f.Farben(farben[name][3], farben[name][4])
  if klein and maxanzahl > 5 then
    gpu.set(x, y, table.concat(nachricht, nil, grenze + 1))
  else
    if name ~= "Tankname" then
      gpu.fill(x, y, breite - grenze, 1, " ")
      gpu.set(x, y + 1, table.concat(nachricht, nil, grenze + 1))
      gpu.fill(x, y + 2, breite - grenze, 1, " ")
    end
  end
end

function f.Farben(vorne, hinten)
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

function f.text(a, b)
  for screenid in component.list("screen") do
    gpu.bind(screenid, false)
    if b then
      gpu.setResolution(gpu.maxResolution())
    else
      f.Farben(0xFFFFFF, 0x000000)
      gpu.set(1, 1, a)
      gpu.setResolution(string.len(a), 1)
    end
    f.Farben(0xFFFFFF, 0x000000)
    gpu.set(1, 1, a)
  end
end

function f.keineDaten()
  Sensorliste = {}
  for k, v in pairs(timer) do
    event.cancel(v)
  end
  f.text("Keine Daten vorhanden")
  timer.tank = event.timer(Wartezeit + 15, f.tank, 1)
  timer.senden = event.timer(Zeit, f.senden, math.huge)
  m.broadcast(port, "tank")
end

function f.tankliste()
  for i in pairs(Sensorliste) do
    f.tank(Sensorliste[i][1], Sensorliste[i][3], Sensorliste[i][8])
  end
end

function o.tankliste(signal)
  local dazu = true
  if version ~= signal[7] then
    event.timer(5, f.update(signal), 1)
  end
  for i in pairs(Sensorliste) do
    if Sensorliste[i][3] == signal[3] then
      dazu = false
      Sensorliste[i] = signal
      break
    end
  end
  if dazu then
    table.insert(Sensorliste, signal)
  end
  for k, v in pairs(timer) do
    event.cancel(v)
  end
  timer.tank = event.timer(Wartezeit + 15, f.tank, 1)
  timer.jetzt = event.timer(2, f.tankliste, 1)
  timer.senden = event.timer(Zeit, f.senden, math.huge)
  timer.tankliste = event.timer(Zeit + 15, f.tankliste, math.huge)
  timer.beenden = event.timer(Wartezeit + 30, f.beenden, 1)
  timer.anzeigen = event.timer(5, f.anzeigen, 1)
end

function o.speichern(signal)
  if not signal[7] then
    if fs.exists("/tank/client" .. signal[8]) then
      local d = io.open("/tank/client" .. signal[8], "r")
      m.send(signal[3], port, "datei", v, d:read("*a"))
      d:close()
    end
  end
end

function f.update(signal)
  for k, v in pairs(dateiliste) do
    local d = io.open("/tank/client" .. v, "r")
    m.send(signal[3], port, "datei", v, d:read("*a"))
    d:close()
  end
  m.send(signal[3], port, "aktualisieren", serialization.serialize(dateiliste))
  return function() end
end

function f.event(...)
  local signal = {...}
  if o[signal[6]] then
    if Sendeleistung < signal[5] + 50 then
      Sendeleistung = signal[5] + 50
    end
    o[signal[6]](signal)
  end
end

function f.senden()
  if m.isWireless() then
    m.setStrength(Sendeleistung)
  end
  Sensorliste = {}
  m.broadcast(port, "tank")
end

function f.test(screenid)
  for screenid in component.list("screen") do
    gpu.bind(screenid, false)
    os.sleep(0.1)
    local _, hoch = component.proxy(screenid).getAspectRatio()
    gpu.bind(screenid)
    if hoch <= 2 then
      gpu.setResolution(160, 16)
    else
      gpu.setResolution(160, 48)
    end
    os.sleep(0.1)
    local function schwarz()
      for i = 0, 15 do
        gpu.setBackground(0x000000)
        print()
        print()
        print()
        os.sleep(0.0001)
      end
    end
    local hex = {0x000000, 0x1F1F1F, 0x3F3F3F, 0x5F5F5F, 0x7F7F7F, 0x9F9F9F, 0xBFBFBF, 0xDFDFDF,
                 0xFFFFFF, 0xDFFFDF, 0xBFFFBF, 0x9FFF9F, 0x7FFF7F, 0x5FFF5F, 0x3FFF3F, 0x1FFF1F,
                 0x00FF00, 0x1FDF00, 0x3FBF00, 0x5F9F00, 0x7F7F00, 0x9F5F00, 0xBF3700, 0xDF1F00,
                 0xFF0000, 0xDF001F, 0xBF003F, 0x9F005F, 0x7F007F, 0x5F009F, 0x3F00BF, 0x1F00DF,
                 0x0000FF, 0x0000DF, 0x0000BF, 0x00009F, 0x00007F, 0x00005F, 0x00003F, 0x00001F,
                 0x000000}
    schwarz()
    for _, farbe in pairs(hex) do
      gpu.setBackground(farbe)
      print(string.rep(" ", 160))
      print(string.rep(" ", 160))
      print(string.rep(" ", 160))
      os.sleep(0.0001)
    end
    schwarz()
  end
end

function f.checkUpdate(text)
  if component.isAvailable("internet") then
    serverVersion = f.checkServerVersion()
  end
  if text then
    term.setCursor(gpu.getResolution())
    print("\nPrüfe Version\n")
    print("Derzeitige Version:    " .. (version or "<FEHLER>"))
    print("Verfügbare Version:    " .. (serverVersion or "<FEHLER>"))
    print()
    os.sleep(2)
  end
  if serverVersion and arg and component.isAvailable("internet") and serverVersion ~= version then
    f.text("Update...")
    if wget("-fQ", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/installieren.lua", "/installieren.lua") then --hier auf master
      require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
      print(pcall(loadfile("/installieren.lua"), "Tank"))
      os.execute("reboot")
    end
  end
end

function debugupdate()
  f.text("Update...")
  require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
  os.execute("pastebin run -f cyF0yhXZ Tank")
end

function f.main()
  --f.test()
  f.Farben(0xFFFFFF, 0x000000)
  f.checkUpdate(true)
  Updatetimer = event.timer(43200, f.checkUpdate, math.huge)
  Updatetimer = event.timer(300, debugupdate, math.huge) --test
  m.open(port)
  f.text("Warte auf Daten")
  event.listen("modem_message", f.event)
  event.listen("component_added", f.anzeigen)
  timer.senden = event.timer(Zeit, f.senden, math.huge)
  timer.tank = event.timer(Zeit + 15, f.tank, 1)
  timer.beenden = event.timer(Wartezeit + 30, f.beenden, 1)
  f.senden()
  event.listen("interrupted", f.beenden)
  event.pull("beenden")
end

function f.beenden()
  event.ignore("modem_message", f.event)
  event.ignore("component_added", f.tank)
  event.ignore("interrupted", f.beenden)
  for k, v in pairs(timer) do
    event.cancel(v)
  end
  event.cancel(Updatetimer)
  event.push("beenden")
  for screenid in component.list("screen") do
    gpu.bind(screenid)
    os.sleep(0.1)
    f.Farben(0xFFFFFF, 0x000000)
    term.clear()
    print("Tankanzeige wird ausgeschaltet")
  end
  f = nil
  o = nil
  os.exit()
end

function f.checkServerVersion()
  local serverVersion
  if wget("-fQ", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/version.txt", "/serverVersion.txt") then
    local d = io.open ("/serverVersion.txt", "r")
    serverVersion = d:read()
    d:close()
    fs.remove("/serverVersion.txt")
  end
  return serverVersion
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tankanzeige")

local ergebnis, grund = pcall(f.main)

if not ergebnis then
  f.text("<FEHLER> f.main")
  os.sleep(2)
  f.text(grund)
end
