-- Robot programm to load the chunk on active redstone signal (white signal from stargate computer)
-- WIP

local component = require("component")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/master/chunkloader.lua' autorun.lua")

function main()
  print("\nPruefe Komponenten\n")
  if component.isAvailable("chunkloader") then
    local c = component.chunkloader
    local chunkloaderstatus = true
    print("- ChunkLoader          ok")
  else
    local chunkloaderstatus = false
    print("- ChunkLoader          fehlt")
  end
  if component.isAvailable("redstone") then
    local r = component.getPrimary("redstone")
    local redstonestatus = true
    print("- Redstone Card        ok")
  else
    print("- Redstone Card        fehlt")
  end
  print("")
  if chunkloaderstatus == true and redstonestatus == true then
    loop()
  end
end

function loop()
  local aktiv = true
  while aktiv == true do
    if r.getInput(1) == 0 then
      os.sleep(10)
      if r.getInput(1) == 0 then
        c.setActive(false)
      else
        c.setActive(true)
      end
    else
      c.setActive(true)
    end
    print("\nredstone input: " .. r.getInput(1)) --test
    if c.isActive() == true then
      print("Chunkloader An")
    elseif c.isActive() == false then
      print("Chunkloader Aus")
    end
    os.sleep(10)
  end
end

main()
