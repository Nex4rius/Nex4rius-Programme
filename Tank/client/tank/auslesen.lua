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
local term            = require("term")
local event           = require("event")
local c               = require("computer")
local fs              = require("filesystem")
local serialization   = require("serialization")

if not component.isAvailable("modem") then
  term.clear()
  print("Fehler kein Modem gefunden")
  os.exit()
end

local m               = component.getPrimary("modem")

local verschieben     = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen       = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local min_update_zeit = 5
local letzter_check   = c.uptime() - min_update_zeit - 1
local letzter_anders  = letzter_check
local port            = 918
local tank            = {}
local f               = {}
local o               = {}

tank[1]               = {}

local adresse, empfangen, version, reichweite, Tankname

local function gt(k)
  local menge = 0
  local maxmenge = 0
  for i = 1, 16 do
    local EU = k.getBatteryCharge(i)
    if EU then
      menge = menge + EU
      maxmenge = maxmenge + k.getMaxBatteryCharge(i)
    end
  end
  return "EU", "EU", "EU", menge, maxmenge
end

local function ic2(k)
  local a = "getStored"
  if not k[a] then
    a = "getEnergy"
  end
  return "EU", "EU", "EU", k[a](), k.getCapacity()
end

local function rf(k)
  return "RF", "RF", "RF", k.getEnergyStored(), k.getMaxEnergyStored()
end
--return name, label, einheit, menge, maxmenge

local andere = {
  {gt, "gt_batterybuffer"},
  {ic2, "chargepad_batbox"},
  {ic2, "chargepad_cesu"},
  {ic2, "chargepad_mfe"},
  {ic2, "chargepad_mfsu"},
  {ic2, "batbox"},
  {ic2, "cesu"},
  {ic2, "mfe"},
  {ic2, "mfsu"},
  {rf, "capacitor_bank"},
  {rf, "energy_device"},
}

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
  if string.len(Tankname) <= 2 then
    Tankname = "false"  
  end
  d:close()
else
  term.clear()
  print("Soll dieser Sensor einen Namen bekommen? [j/N]")
  local d = io.open("/home/Tankname", "w")
  if string.lower(io.read()) == "j" then
    print("Bitte Namen eingeben")
    term.write("Eingabe: ")
    Tankname = io.read()
    if string.len(Tankname) <= 2 then
      d:write("false")
    else
      d:write(Tankname)
    end
  else
    d:write("false")
  end
  d:close()
  Tankname = "false"  
end

local function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

function f.check()
  tank = {}
  local i = 1
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"tank_controller", "transposer"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for side = 0, 5 do
        if type(k.getFluidInTank(side)) == "table" then
          for a, b in pairs(k.getFluidInTank(side)) do
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
                tank[i].einheit = "mb"
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
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"me_controller", "me_interface"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for _, typ in pairs({{"mb", "getFluidsInNetwork"}, {"", "getEssentiaInNetwork"}, {"", "GetGasesInNetwork"}}) do
        if k[typ[2]] then
          for _, b in pairs(k[typ[2]]()) do
            if type(b) == "table" then
              if typ[2] == "getEssentiaInNetwork" then
                b.label = string.sub(b.label, 0, string.len(b.label) - 4)
                b.name = string.lower(b.label)
              end
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
                tank[i].einheit = typ[1]
                tank[i].menge = b.amount
                tank[i].maxmenge = b.amount
                i = i + 1
              else
                tank[c].menge = tank[c].menge + b.amount
                tank[c].maxmenge = tank[c].maxmenge + b.amount
              end
            end
          end
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"blockjar_0", "blockjar_3", "blockcreativejar_3", "blocktube_2", "blocktube_4", "blockmetaldevice_1", "blockstonedevice_14", "blockessentiareservoir"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      local name = k.getEssentiaType(0)
      if name then
        local label = firstToUpper(name)
        local menge = k.getEssentiaAmount(0)
        local maxmenge = 64
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_normal", "jar_void"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 250
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_brass"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 275
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_thaumium"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 350
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_eldritch"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 500
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_mithrillium"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 1000
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_adaminite"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 2000
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, CompName in pairs({"jar_mithminite"}) do
    for adresse in pairs(component.list(CompName)) do
      local k = component.proxy(adresse)
      for label, menge in pairs(k.getAspects()) do
        local name = label:lower()
        local maxmenge = 4000
        local dazu = true
        local c
        for j, k in pairs(tank) do
          if name == k.name then
            dazu = false
            c = j
            break
          end
        end
        if dazu then
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = ""
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        else
          tank[c].menge = tank[c].menge + menge
          tank[c].maxmenge = tank[c].maxmenge + maxmenge
        end
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  for _, v in pairs(andere) do
    for adresse in pairs(component.list(v[2])) do
      local k = component.proxy(adresse)
      local name, label, einheit, menge, maxmenge = v[1](k)
      if type(tank[i - 1]) == "table" then
        if tank[i - 1].name == name then
          tank[i - 1].menge = tank[i - 1].menge + menge
          tank[i - 1].maxmenge = tank[i - 1].maxmenge + maxmenge
        else
          tank[i] = {}
          tank[i].name = name
          tank[i].label = label
          tank[i].einheit = einheit
          tank[i].menge = menge
          tank[i].maxmenge = maxmenge
          i = i + 1
        end
      else
        tank[i] = {}
        tank[i].name = name
        tank[i].label = label
        tank[i].einheit = einheit
        tank[i].menge = menge
        tank[i].maxmenge = maxmenge
        i = i + 1
      end
    end
  end
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  ---------------------------------------------------------------------------
  print("\n\n\n" .. Tankname .. "\n" .. letzter_check .. "------------------------------")
  for i in pairs(tank) do
    if tank[i].name then
      print(string.format("%s - %s: %s/%s %.1f%%", tank[i].name, tank[i].label, tank[i].menge, tank[i].maxmenge, tank[i].menge / tank[i].maxmenge * 100))
    end
  end
  letzter_check = c.uptime()
  return tank
end

function f.serialize(eingabe)
  if type(eingabe) == "table" then
    local ausgabe = {}
    local i = 1
    if Tankname then
      ausgabe[i] = string.format([==[[%s] = {name="Tankname", label="%s", menge="1", maxmenge="1", einheit=""}, ]==], i, Tankname)
      i = i + 1
    end
    for k, v in pairs(eingabe) do
      if v.name then
        ausgabe[i] = string.format([==[[%s] = {name="%s", label="%s", menge="%s", maxmenge="%s", einheit="%s"}, ]==], i, v.name, v.label, v.menge, v.maxmenge, v.einheit)
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
    local d = io.open("/update" .. signal[7], signal[9])
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
    for k, v in pairs(daten) do
      verschieben("/update/" .. v, "/" .. v)
    end
    entfernen("/update")
    print("Update vollständig")
    o.datei = nil
    os.sleep(1)
    for i = 5, 1, -1 do
      print(string.format("\nNeustarten in %ss", i))
      os.sleep(1)
    end
    require("computer").shutdown(true)
  end
end

function o.tank(signal)
  if c.uptime() - letzter_check > min_update_zeit then
    f.senden(signal, "tankliste", version, f.serialize(f.check()))
  end
end

function f.anders()
  if c.uptime() - letzter_anders > min_update_zeit then
    m.broadcast(port + 1, "tankliste", version, f.serialize(f.check()))
    letzter_anders = c.uptime()
  end
end

function f.lange_nichts()
  if c.uptime() - letzter_anders > 6000 then
    m.broadcast(port + 1, "tankliste", version, f.serialize(f.check()))
    letzter_anders = c.uptime()
  end
end

function f.loop(...)
  print("\n\n")
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
  m.setWakeMessage("tank", true)
  if m.isWireless() then
    m.setStrength(math.huge)
  end
  term.clear()
  print("Sende Anmeldung")
  print("\n" .. Tankname)
  f.anders()
  print("Warte auf Antwort...")
  local langes_warten = event.timer(600, f.lange_nichts, math.huge)
  event.listen("modem_message", f.loop)
  event.listen("component_added", f.anders)
  event.listen("component_removed", f.anders)
  pcall(os.sleep, math.huge)
  event.ignore("modem_message", f.loop)
  event.ignore("component_added", f.anders)
  event.ignore("component_removed", f.anders)
  event.cancel(langes_warten)
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tanksensor")

print(pcall(f.main))
