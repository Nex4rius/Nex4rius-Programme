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
  chunk = true
  aktiv = true
  while aktiv == true do
    print(r.getInput(1))
    if r.getInput(1) > 0 and chunk == true then
      c.setActive(true)
      chunk = false
      print("an")
    elseif r.getInput(1) == 0 and chunk == false then
      os.sleep(10)
      chunk = true
      c.setActive(false)
      print("aus")
    end
    if c.isActive() == true then
      print("Chunkloader An")
    else
      print("Chunkloader Aus")
    end
    os.sleep(10)
  end
end

main()
