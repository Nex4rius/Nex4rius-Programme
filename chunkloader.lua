-- Robot programm to load the chunk on active redstone signal

component = require("component")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/master/chunkloader.lua' autorun.lua")

function main()
  print("\nPruefe Komponenten\n")
  if component.isAvailable("chunkloader") then
    c = component.chunkloader
    chunkloaderstatus = true
    print("- ChunkLoader          ok")
  else
    chunkloaderstatus = false
    print("- ChunkLoader          fehlt")
  end
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
    redstonestatus = true
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
  aktiv = true
  while aktiv == true do
    if r.getInput(1) == 0 then
      os.sleep(10)
      c.setActive(false)
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
