-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local fs = require("filesystem")
local wget = loadfile("/bin/wget.lua")
local move = loadfile("/bin/mv.lua")
if not versionTyp then
  local versionTyp = require("shell").parse(...)[1]
end

local function Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/" .. versionTyp .. "/Stargate-Programm"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/master/Stargate-Programm"
  end
end

if fs.exists("/stargate/Sicherungsdatei.lua") then
  IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  Sprache = ""
  control = "On"
  autoUpdate = false
  installieren = false
end

f = io.open ("/autorun.lua", "w")
f:write('-- pastebin run -f wLK1gCKt\n')
f:write('-- von Nex4rius\n')
f:write('-- https://github.com/Nex4rius/Stargate-Programm\n\n')
f:write('local args = require("shell").parse(...)[1]\n\n')
f:write('if type(args) == "string" then\n')
f:write('  loadfile("/stargate/check.lua")(args)\n')
f:write('else\n')
f:write('  loadfile("/stargate/check.lua")()\n')
f:write('end\n\n')
f:close()

function installieren()
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local update = {}
  update[1] = wget("-f", Pfad(versionTyp) .. "/autorun.lua",                        "/update/autorun.lua")
  update[2] = wget("-f", Pfad(versionTyp) .. "/stargate/check.lua",                 "/update/stargate/check.lua")
  update[3] = wget("-f", Pfad(versionTyp) .. "/stargate/version.txt",               "/update/stargate/version.txt")
  update[4] = wget("-f", Pfad(versionTyp) .. "/stargate/adressen.lua",              "/update/stargate/adressen.lua")
  update[5] = wget("-f", Pfad(versionTyp) .. "/stargate/Sicherungsdatei.lua",       "/update/stargate/Sicherungsdatei.lua")
  update[6] = wget("-f", Pfad(versionTyp) .. "/stargate/Kontrollprogramm.lua",      "/update/stargate/Kontrollprogramm.lua")
  update[7] = wget("-f", Pfad(versionTyp) .. "/stargate/schreibSicherungsdatei.lua","/update/stargate/schreibSicherungsdatei.lua")
  update[8] = wget("-f", Pfad(versionTyp) .. "/stargate/sprache/deutsch.lua",       "/update/stargate/sprache/deutsch.lua")
  update[9] = wget("-f", Pfad(versionTyp) .. "/stargate/sprache/english.lua",       "/update/stargate/sprache/english.lua")
  update[10]= wget("-f", Pfad(versionTyp) .. "/stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  for i = 1, 10 do
    if update[i] == true then
      updateKomplett = true
    else
      updateKomplett = false
      print(sprachen.fehlerName .. i)
      os.sleep(5)
      break
    end
  end
  if updateKomplett == true then
    fs.makeDirectory("/stargate/sprache")
    move("-f", "/update/autorun.lua",                         "/autorun.lua")
    move("-f", "/update/stargate/check.lua",                  "/stargate/check.lua")
    move("-f", "/update/stargate/version.txt",                "/stargate/version.txt")
    if fs.exists("/stargate/adressen.lua") == false then
      move(    "/update/stargate/adressen.lua",               "/stargate/adressen.lua")
    end
    if fs.exists("/stargate/Sicherungsdatei.lua") == false then
      move(    "/update/stargate/Sicherungsdatei.lua",        "/stargate/Sicherungsdatei.lua")
    end
    move("-f", "/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    move("-f", "/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    move("-f", "/update/stargate/sprache/deutsch.lua",        "/stargate/sprache/deutsch.lua")
    move("-f", "/update/stargate/sprache/english.lua",        "/stargate/sprache/english.lua")
    move("-f", "/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    print()
    if versionTyp == "beta" then
      f = io.open ("/stargate/version.txt", "r")
      version = f:read()
      f:close()
      f = io.open ("/stargate/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
  end
  installieren = true
  loadfile("/stargate/schreibSicherungsdatei.lua")(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  loadfile("/bin/rm.lua")("-v", "/update")
  loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  --loadfile("/autorun.lua")("no")
  --os.exit()
  require("computer").shutdown(true)
end

if fs.exists("/stargate/sicherNachNeustart.lua") then
  if fs.exists("/stargate/adressen.lua") then
    dofile("/stargate/adressen.lua")
  end
  f = io.open("/stargate/adressen.lua", "w")
  f:write('-- pastebin run -f wLK1gCKt\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n')
  f:write('-- Put your own stargate addresses here\n')
  f:write('-- "" for no Iris Code\n')
  f:write('--\n\n')
  f:write('return {\n')
  f:write('--{"<Name>","<Adresse>","<IDC>"},\n')
  for k in pairs(adressen) do
    f:write(string.format('  {"%s", "%s", "%s"},\n', adressen[k][1], adressen[k][2], adressen[k][3]))
  end
  f:write('}')
  f:close()
  dofile("/stargate/sicherNachNeustart.lua")
  loadfile("/bin/rm.lua")("/stargate/sicherNachNeustart.lua")
end

if component.isAvailable("internet") then
  installieren()
end
