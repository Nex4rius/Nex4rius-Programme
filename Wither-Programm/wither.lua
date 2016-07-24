-- pastebin run -f j9duLPvp
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Wither-Programm

local WitherSkeletonSkull       = 0
local WitherSkeletonSkullPlatz  = 6
local SoulSand                  = 0
local SoulSandPlatz             = 8
local WardedGlass               = 0
local WardedGlassPlatz          = 2
local Treibstoff                = 0
local TreibstoffPlatz           = 4

function chunkloader(zustand)
  if chunkloaderstatus == true then
    c.setActive(zustand)
  end
end

function generator()
  if generatorstatus == true then
    if Treibstoff > 0 then
      r.select(Treibstoff)
      g.insert()
    end
  end
end

function placeWither()
  if chunkloaderstatus == true then
    print(spawnWitherChunkloaderAn)
  else
    print(spawnWither)
  end
  r.turnRight()
  r.forward()
  r.turnLeft()
  r.forward()
  r.forward()
  r.turnLeft()
  r.forward()
  r.turnRight()
  r.use()
  r.forward()
  r.forward()
  r.select(WitherSkeletonSkull)
  r.turnLeft()
  r.place()
  r.turnAround()
  r.place()
  r.down()
  r.select(SoulSand)
  r.place()
  r.turnAround()
  r.place()
  r.placeDown()
  r.up()
  r.placeDown()
  r.turnRight()
  r.back()
  r.select(WitherSkeletonSkull)
  r.place()
  r.back()
  r.select(WardedGlass)
  r.place()
  r.turnLeft()
  r.forward()
  r.turnLeft()
  r.forward()
  r.forward()
  r.turnLeft()
  r.forward()
  r.turnLeft()
end

function checkWand()
  item = inv.getStackInInternalSlot(13)
  r.select(13)
  if item then
    if item.name == "Thaumcraft:WandCasting" then
      inv.equip()
      return true
    end
  else
    inv.equip()
    item = inv.getStackInInternalSlot(13)
    if item then
      if item.name == "Thaumcraft:WandCasting" then
        inv.equip()
        return true
      else
        return false
      end
    end
  end
end

function checkInventory()
  for i = 1, 16 do
    item = inv.getStackInInternalSlot(i)
    if item then
      name = item.name .. ":" .. item.damage
      if "minecraft:skull:1" == name then
        if 3 <= item.size then
          WitherSkeletonSkull = i
        end
        WitherSkeletonSkullPlatz = 6 - item.size
      end
      if "minecraft:soul_sand:0" == name then
        if 4 <= item.size then
          SoulSand = i
        end
        SoulSandPlatz = 8 - item.size
      end
      if "Thaumcraft:blockCosmeticOpaque:2" == name then
        if 1 <= item.size then
         WardedGlass = i
        end
        WardedGlassPlatz = 2 - item.size
      end
      if "Railcraft:fuel.coke:0" == name or "minecraft:coal" == item.name or "Thaumcraft:ItemResource:0" == name then
        if 1 <= item.size then
         Treibstoff = i
        end
        TreibstoffPlatz = 4 - item.size
      end
    end
  end
end

function invRefill()
  for i = 1, inv.getInventorySize(0) do
    item = inv.getStackInSlot(0, i)
    if item then
      name = item.name .. ":" .. item.damage
      if "minecraft:skull:1" == name then
        if WitherSkeletonSkull == 0 then
          r.select(1)
        else
          r.select(WitherSkeletonSkull)
        end
        inv.suckFromSlot(0, i, WitherSkeletonSkullPlatz)
      end
      if "minecraft:soul_sand:0" == name then
        if SoulSand == 0 then
          r.select(1)
        else
          r.select(SoulSand)
        end
        inv.suckFromSlot(0, i, SoulSandPlatz)
      end
      if "Thaumcraft:blockCosmeticOpaque:2" == name then
        if WardedGlass == 0 then
          r.select(1)
        else
          r.select(WardedGlass)
        end
        inv.suckFromSlot(0, i, WardedGlassPlatz)
      end
      if generatorstatus == true then
        if "Railcraft:fuel.coke:0" == name or "minecraft:coal" == item.name or "Thaumcraft:ItemResource:0" == name then
          if Treibstoff == 0 then
            r.select(1)
          else
            r.select(Treibstoff)
          end
          inv.suckFromSlot(0, i, TreibstoffPlatz)
        end
      end
    end
  end
end

function reset()
  WitherSkeletonSkull = 0
  WitherSkeletonSkullPlatz = 64
  SoulSand = 0
  SoulSandPlatz = 64
  WardedGlass = 0
  WardedGlassPlatz = 64
  Treibstoff = 0
  TreibstoffPlatz = 4
end

function WaitForNetherStar()
  wait = true
  print(warteNetherStar)
  while wait do
    os.sleep(5)
    for i = 1, inv.getInventorySize(3) do
      item = inv.getStackInSlot(3, i)
      if item then
        name = item.name .. ":" .. item.damage
        if "minecraft:nether_star:0" == name then
          r.select(16)
          inv.suckFromSlot(3, i)
          NetherStar = NetherStar + 1
          print(AnzahlNetherStar .. NetherStar)
          schreibSicherungsdatei()
          for j = 1, inv.getInventorySize(0) do
            inv.dropIntoSlot(0, j)
          end
          wait = false
          break
        end
      end
    end
  end
end

function main()
  print("")
  while running do
    if checkWand() == true then
      checkInventory()
      invRefill()
      checkInventory()
      generator()
      if WitherSkeletonSkull == 0 or SoulSand == 0 or WardedGlass == 0 then
        if chunkloaderstatus == true then
          print(materialFehltMitChunk)
        else
          print(materialFehlt)
        end
        chunkloader(false)
        os.sleep(300)
      else
        chunkloader(true)
        placeWither()
        WaitForNetherStar()
      end
      reset()
    else
      print(ZauberstabFehlt)
      if chunkloaderstatus == true then
        print(ZauberstabFehltwarteChunk)
      else
        print(ZauberstabFehltwarte)
      end
      chunkloader(false)
      os.sleep(60)
    end
    print("")
  end
end

running = true

main()
