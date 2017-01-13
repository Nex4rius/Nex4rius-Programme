local component = require("component")
local computer = require("computer")
local redstone = component.redstone
local tractor = component.tractor_beam
local inv = component.inventory_controller
local fs = require("filesystem")
local r = require("robot")
local term = require("term")
local farmlaenge
local richtung = true
local weiter = true
local oben = 0

function energie()
  io.write("Prüfe Energie - ")
  local energy = computer.energy() / computer.maxEnergy()
  if energy > 0.98 then
    io.write(string.format("%.f", energy * 100) .. " % - OK\n")
    return true
  else
    io.write(string.format("%.f", energy * 100) .. " % - unzureichende Energie\n")
    return false
  end
end

function invleer()
  local inventar
  print("Prüfe Inventar")
  for i = 1, 16 do
    local a = inv.getStackInInternalSlot(i)
    if a then
      inventar = true
      if a.name == "minecraft:cobblestone" then
        weiter = false
        print("Cobblestone entdeckt\nBeende Programm")
        os.exit()
        return false
      end
      r.select(i)
      inv.equip()
      local wartezeit = a.size / 3 + 1
      print("Leere Inventar - Warte " .. string.format("%.f", wartezeit) .. "s")
      os.sleep(wartezeit)
    end
  end
  if inventar then
    print("Inventarleerung abgeschlossen")
  else
    print("Inventar leer")
  end
  return true
end

function farm()
  richtung = true
  if redstone then
    redstone.setOutput(0, 15)
  end
  if not farmlaenge then
    r.up()
    farmlaenge = -1
    io.write("Farmlänge bestimmen ... ")
    while r.forward() do
      farmlaenge = farmlaenge + 1
    end
    print(farmlaenge)
    for i = 0, farmlaenge do
      r.back()
    end
    r.down()
  end
  print("Ernte einholen")
  r.up()
  r.forward()
  for i = 0, 8 do
    ernten()
  end
  r.turnLeft()
  while r.forward() do end
  r.turnLeft()
  for i = 0, farmlaenge do
    r.back()
  end
  r.down()
  print("Ernte komplett")
end

function ernten()
  for i = 1, farmlaenge do
    if oben > 0 then
      if r.down() then
        oben = oben - 1
      end
    end
    r.useDown()
    tractor.suck()
    if not r.forward() then
      r.up()
      r.forward()
      oben = oben + 1
    end
  end
  if richtung then
    r.turnLeft()
    r.useDown()
    tractor.suck()
    r.forward()
    r.turnLeft()
    richtung = false
  else
    r.turnRight()
    r.useDown()
    tractor.suck()
    r.forward()
    r.turnRight()
    richtung = true
  end
end

function reset()
  print("Reset Position")
  local runter = -2
  while r.up() do end
  while r.back() do end
  while r.down() do
    runter = runter + 1
    if runter > 0 then
      break
    end
  end
  if runter == 0 then
    r.turnRight()
    if not r.forward() then
      r.turnLeft()
      r.forward()
      r.forward()
      r.turnRight()
      return reset()
    else
      r.forward()
      while r.down() do end
      print("Warte 10s")
      os.sleep(10)
      return true
    end
  else
    r.turnLeft()
    return reset()
  end
end

function main()
  invleer()
  r.up()
  while energie() do end
  reset()
  while weiter do
    if energie() then
      if invleer() then
        farm()
        invleer()
        print("Warte 300s\n")
        os.sleep(300)
      end
    else
      if reset() then
        print("Auflanden")
        while not energie() do
          os.sleep(1)
        end
      else
        print("Reset fehlgeschlagen\nHerunterfahren")
        os.execute("shutdown")
      end
    end
  end
end

main()
