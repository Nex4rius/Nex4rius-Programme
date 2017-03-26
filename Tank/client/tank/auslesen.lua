-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

local component  = require("component")
local term       = require("term")
local event      = require("event")
local c          = require("computer")
local fs         = require("filesystem")

local m          = component.modem

local standby    = function() end
local tps        = function() return 20 end
local port       = 70
local maxzeit    = 30
local tpsZeit    = 1
local reichweite = 400
local zeit       = maxzeit
local tank       = {}

local tankalt, adresse, empfangen, version

tank[1]          = {}

if fs.exists("/bin/standby.lua") then
  standby        = require("standby")
end

if fs.exists("/bin/tps.lua") then
  tps            = require("tps")
end

if fs.exists("/tank/version.txt") then
    local f = io.open ("/tank/version.txt", "r")
    version = f:read()
    f:close()
  else
    version = "<FEHLER>"
end

function check()
  tank, tankalt = {}, tank
  local i = 1
  for adresse, name in pairs(component.list("tank_controller")) do
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
  term.clear()
  for i in pairs(tank) do
    if tank[i].name ~= nil then
      print(string.format("%s - %s: %s/%s %.1f%%", tank[i].name, tank[i].label, tank[i].menge, tank[i].maxmenge, tank[i].maxmenge / tank[i].menge))
    end
  end
  return anders(tank, tankalt), tank
end

function anders(tank, tankalt)
  for i in pairs(tank) do
    if type(tank[i]) == "table" and type(tankalt[i]) == "table" then
      if tank[i].menge ~= tankalt[i].menge then
        return true
      end
    else
      return true
    end
  end
  return false
end

function serialize(a)
  if type(a) == "table" then
    local ausgabe = ""
    for k in pairs(a) do
      if a[k].name ~= nil then
        ausgabe = string.format([[%s{name="%s", label="%s", menge="%s", maxmenge="%s"}, ]], ausgabe, a[k].name, a[k].label, a[k].menge, a[k].maxmenge)
      end
    end
    return "{" .. ausgabe .. "}"
  end
end

function aktualisieren()
end

function senden(warten, nachricht)
  if type(empfangen) == "table" then
    if empfangen[6] == "update" then
      adresse = empfangen[3]
      if type(empfangen[5]) == "number" and m.isWireless() then
        m.setStrength(tonumber(empfangen[5] + 5))
      end
      if tostring(version) ~= tostring(empfangen[7]) then
        aktualisieren()
      end
    end
  end
  m.broadcast(port, serialize(nachricht))
  return warten
end

function loop()
  zeit = maxzeit * tpsZeit
  if senden(check()) then
    zeit = maxzeit / 3
  end
  os.sleep(5)
  empfangen = {event.pull(zeit, "modem_message")}
  standby()
  local a = tps()
  if     a >= 15 then
    tpsZeit = 1
  elseif a >= 10 then
    tpsZeit = 1.5
  elseif a >= 5 then
    tpsZeit = 2
  else
    tpsZeit = 3
  end
end

function main()
  if m.isWireless() then
    m.setStrength(tonumber(reichweite + 5))
  end
  m.open(port + 1)
  while true do
    if not pcall(loop) then
      standby()
      os.sleep(5)
    end
  end
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tank Client")

main()
