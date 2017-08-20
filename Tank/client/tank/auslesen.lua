-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

os.sleep(1)

local component     = require("component")
local term          = require("term")
local event         = require("event")
local c             = require("computer")
local fs            = require("filesystem")
local serialization = require("serialization")

local m             = component.modem

local verschieben   = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen     = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local port          = 918
local tank          = {}
local f             = {}
local o             = {}

tank[1]             = {}

local tankalt, adresse, empfangen, version, reichweite, Tankname


if fs.exists("/tank/version.txt") then
  local d = io.open ("/tank/version.txt", "r")
  version = d:read()
  d:close()
else
  version = "<FEHLER>"
end

if fs.exists("/home/Tankname") then
  local d = io.open("/home/Tankname", "r")
  Tankname = d:read()
  d:close()
  if Tankname == "false" then
    Tankname = nil
  end
else
  term.clear()
  print("Soll dieser Sensor einen Namen bekommen? [j/N]")
  if string.lower(io.read()) == "j" then
    print("Bitte Namen eingeben")
    term.write("Eingabe: ")
    Tankname = io.read()
    local d = io.open("/home/Tankname", "w")
    d:write(Tankname)
    d:close()
  else
    local d = io.open("/home/Tankname", "w")
    d:write("false")
    d:close()
  end
end

function f.check()
  tank, tankalt = {}, tank
  local i = 1
  for _, CompName in pairs({"tank_controller", "transposer"}) do
    for adresse, name in pairs(component.list(CompName)) do
      for side = 0, 5 do
        if type(component.proxy(adresse).getFluidInTank(side)) == "table" then
          for a, b in pairs(component.proxy(adresse).getFluidInTank(side)) do
            if type(a) == "number" then
              local dazu = true
              local c
              for j, k in pairs(tank) do
                if b.name == k.name then
                  dazu = false
                  c = j
                  break
                end
              end
              if dazu then
                tank[i] = {}
                tank[i].name = b.name
                tank[i].label = b.label
                tank[i].menge = b.amount
                tank[i].maxmenge = b.capacity
                i = i + 1
              else
                tank[c].menge = tank[c].menge + b.amount
                tank[c].maxmenge = tank[c].maxmenge + b.capacity
              end
            end
          end
        end
      end
    end
  end
  term.clear()
  for i in pairs(tank) do
    if tank[i].name ~= nil then
      print(string.format("%s - %s: %s/%s %.1f%%", tank[i].name, tank[i].label, tank[i].menge, tank[i].maxmenge, tank[i].menge / tank[i].maxmenge))
    end
  end
  return tank
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

function f.serialize(eingabe)
  if type(eingabe) == "table" then
    local ausgabe = {}
    local i = 0
    if Tankname then
      i = i + 1
      ausgabe[i] = string.format([==[[%s] = {name="Tankname", label="%s", menge="0", maxmenge="0"}, ]==], i, Tankname)
    end
    for k, v in spairs(eingabe, function(t,a,b) return tonumber(t[b].menge) < tonumber(t[a].menge) end) do
      if v.name ~= nil then
        i = i + 1
        ausgabe[i] = string.format([==[[%s] = {name="%s", label="%s", menge="%s", maxmenge="%s"}, ]==], i, v.name, v.label, v.menge, v.maxmenge)
      end
    end
    return "{" .. table.concat(ausgabe) .. "}"
  elseif type(eingabe) == "function" then
    return false, "<FEHLER> Funktionen können nicht gesendet werden" --nichts
  else
    return eingabe
  end
end

function o.datei(empfangen)
  if not fs.exists("/update/tank") then
    fs.makeDirectory("/update/tank")
  end
  if type(empfangen[7]) == "string" and type(empfangen[8]) == "string" and not fs.exists("/update" .. empfangen[7]) then
    print("\nEmpfange Datei ... " .. empfangen[7])
    local d = io.open("/update" .. empfangen[7], "w")
    d:write(empfangen[8])
    d:close()
    f.senden(empfangen, "speichern", fs.exists(empfangen[7]))
  else
    print("<FEHLER>")
    print("empfangen[7] " .. tostring(empfangen[7]))
    print("empfangen[8] " .. tostring(empfangen[8]))
    f.senden(empfangen, "speichern", false)
  end
end

function o.aktualisieren(empfangen)
  local weiter = true
  local daten = serialization.unserialize(empfangen[7])
  for k, v in pairs(daten) do
    if not fs.exists("/update" .. v) then
      weiter = false
      print("<FEHLER>")
      print("Aktualisierung abgebrochen")
      print("Datei fehlt: " .. tostring(v))
      f.senden(empfangen, "update", false, v)
      break
    end
  end
  if weiter then
    print("Ersetze alte Dateien")
    local function kopieren(...)
      for i in fs.list(...) do
        if fs.isDirectory(i) then
          kopieren(i)
        end
        verschieben("/update/" .. i, "/" .. i)
      end
    end
    kopieren("/update")
    entfernen("/update")
    print("Update vollständig")
    os.sleep(1)
    f.senden(empfangen, "update", true)
    for i = 5, 1, -1 do
      print(string.format("\nNeustarten in %ss", i))
      os.sleep(1)
    end
    require("computer").shutdown(true)
  end
end

function o.version(empfangen)
  f.senden(empfangen, version)
end

function o.tank(empfangen)
  f.senden(empfangen, f.serialize(f.check()))
end

function f.loop()
  empfangen = {event.pull("modem_message")}
  print(empfangen[6])
  if o[empfangen[6]] then
    o[empfangen[6]](empfangen)
  end
end

function f.senden(empfangen, nachricht, ...)
  if m.isWireless() then
    m.setStrength(tonumber(empfangen[5]) + 30)
  end
  m.send(empfangen[3], empfangen[4], f.serialize(nachricht), ...)
end

function f.main()
  m.open(port)
  if  m.isWireless() then
    m.setStrength(math.huge)
  end
  m.broadcast(port, "anmelden")
  term.clear()
  print("Sende Anmeldung")
  print("Warte auf Antwort")
  while true do
    local ergebnis, grund = pcall(f.loop)
    if not ergebnis then
      print(grund)
      os.sleep(5)
    end
  end
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tank Client")

f.main()
