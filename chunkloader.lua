-- Robot programm to load the chunk on active redstone signal (eg. white signal from stargate programm)

serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
versionTyp = "master/"

Pfad = serverAddresse .. versionTyp
os.execute("wget -f " .. Pfad .. "chunkloader.lua autorun.lua")

print("Pruefe Komponenten\n")
if component.isAvailable("redstone") then
  print("- Redstone Card        ok")
  r = component.getPrimary("redstone")
  aktiv = true
--  while aktiv true do
    
--  end
else
  print("- Redstone Card        fehlt")
end
