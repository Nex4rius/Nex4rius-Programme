-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

os.sleep(2)

local io            = io
local os            = os
local table         = table
local string        = string
local print         = print
local pcall         = pcall
local require       = require
local loadfile      = loadfile

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

local adresse, empfangen, version, reichweite, Tankname


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
  --if Tankname == "false" then
  --  Tankname = nil
  --end
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
  tank = {}
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
  for _, CompName in pairs({"chargepad_batbox", "batbox", "chargepad_cesu", "cesu", "chargepad_mfe", "mfe", "chargepad_mfsu", "mfsu"}) do
    for adresse, name in pairs(component.list(CompName)) do
      if type(tank[i - 1]) == "table" then
        if tank[i - 1].name == "EU" then
          tank[i - 1].menge = tank[i - 1].menge + component.proxy(adresse).getStored()
          tank[i - 1].maxmenge = tank[i - 1].maxmenge + component.proxy(adresse).getCapacity()
        else
          tank[i] = {}
          tank[i].name = "EU"
          tank[i].label = "EU"
          tank[i].menge = component.proxy(adresse).getStored()
          tank[i].maxmenge = component.proxy(adresse).getCapacity()
          i = i + 1
        end
      else
        tank[i] = {}
        tank[i].name = "EU"
        tank[i].label = "EU"
        tank[i].menge = component.proxy(adresse).getStored()
        tank[i].maxmenge = component.proxy(adresse).getCapacity()
        i = i + 1
      end
    end
  end
  for _, CompName in pairs({"capacitor_bank"}) do
    for adresse, name in pairs(component.list(CompName)) do
      if type(tank[i - 1]) == "table" then
        if tank[i - 1].name == "RF" then
          tank[i - 1].menge = tank[i - 1].menge + component.proxy(adresse).getEnergyStored()
          tank[i - 1].maxmenge = tank[i - 1].maxmenge + component.proxy(adresse).getMaxEnergyStored()
        else
          tank[i] = {}
          tank[i].name = "RF"
          tank[i].label = "RF"
          tank[i].menge = component.proxy(adresse).getEnergyStored()
          tank[i].maxmenge = component.proxy(adresse).getMaxEnergyStored()
          i = i + 1
        end
      else
        tank[i] = {}
        tank[i].name = "RF"
        tank[i].label = "RF"
        tank[i].menge = component.proxy(adresse).getEnergyStored()
        tank[i].maxmenge = component.proxy(adresse).getMaxEnergyStored()
        i = i + 1
      end
    end
  end
  print("\n\n\n")
  for i in pairs(tank) do
    if tank[i].name ~= nil then
      print(string.format("%s - %s: %s/%s %.1f%%", tank[i].name, tank[i].label, tank[i].menge, tank[i].maxmenge, tank[i].menge / tank[i].maxmenge * 100))
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
    local i = 1
    if Tankname then
      ausgabe[i] = string.format([==[[%s] = {name="Tankname", label="%s", menge="1", maxmenge="1"}, ]==], i, Tankname)
      i = i + 1
    end
    for k, v in spairs(eingabe, function(t,a,b) return tonumber(t[b].menge) < tonumber(t[a].menge) end) do
      if v.name ~= nil then
        ausgabe[i] = string.format([==[[%s] = {name="%s", label="%s", menge="%s", maxmenge="%s"}, ]==], i, v.name, v.label, v.menge, v.maxmenge)
        i = i + 1
      end
    end
    return "{" .. table.concat(ausgabe) .. "}"
  elseif type(eingabe) == "function" then
    return false, "<FEHLER> Funktionen können nicht gesendet werden"
  else
    return eingabe
  end
end

function o.datei(signal)
  if not fs.exists("/update/tank") then
    fs.makeDirectory("/update/tank")
  end
  if type(signal[7]) == "string" and type(signal[8]) == "string" then
    print("\nEmpfange Datei ... " .. signal[7])
    local d = io.open("/update" .. signal[7], "w")
    print(signal[8]) -- debug
    d:write(signal[8])
    d:close()
    f.senden(signal, "speichern", fs.exists("/update" .. signal[7]), signal[7])
  else
    print("<FEHLER>")
    print("signal[7] " .. tostring(signal[7]))
    print("signal[8] " .. tostring(signal[8]))
    f.senden(signal, "speichern", false, signal[7])
  end
end

function o.aktualisieren(signal)
  local weiter = true
  local daten = serialization.unserialize(signal[7])
  for k, v in pairs(daten) do
    if not fs.exists("/update" .. v) then
      weiter = false
      print("<FEHLER>")
      print("Datei fehlt: " .. tostring(v))
      f.senden(signal, "speichern", false, v)
    end
  end
  if weiter then
    print("Ersetze alte Dateien")
    --local function kopieren(...)
    --  for i in fs.list(...) do
    --    if fs.isDirectory(i) then
    --      kopieren(i)
    --    end
    --    verschieben("/update/" .. i, "/" .. i)
    --  end
    --end
    --kopieren("/update")
    for k, v in pairs(daten) do
      --verschieben("/update/" .. v, "/" .. v)
    end
    --entfernen("/update")
    print("Update vollständig")
    os.sleep(1)
    for i = 5, 1, -1 do
      print(string.format("\nNeustarten in %ss", i))
      os.sleep(1)
    end
    require("computer").shutdown(true)
  end
end

function o.tank(signal)
  f.senden(signal, "tankliste", version, f.serialize(f.check()))
end

function f.loop(...)
  print("\n\n\n")
  print(...)
  local signal = {...}
  print(signal[6])
  if o[signal[6]] then
    o[signal[6]](signal)
  end
end

function f.senden(signal, name, nachricht, ...)
  if m.isWireless() then
    m.setStrength(tonumber(signal[5]) + 50)
  end
  m.send(signal[3], signal[4] + 1, name, f.serialize(nachricht), ...)
end

function f.main()
  m.open(port)
  if m.isWireless() then
    m.setStrength(math.huge)
  end
  term.clear()
  print("Sende Anmeldung")
  m.broadcast(port + 1, "tankliste", version, f.serialize(f.check()))
  print("Warte auf Antwort...")
  event.listen("modem_message", f.loop)
  pcall(os.sleep, math.huge)
  event.ignore("modem_message", f.loop)
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tanksensor")

print(pcall(f.main))
