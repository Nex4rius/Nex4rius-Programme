-- pastebin run -f j9duLPvp
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Wither-Programm

local fs          = require("filesystem")
local arg         = require("shell").parse(...)[1]
local wget        = loadfile("/bin/wget.lua")
local move        = loadfile("/bin/mv.lua")
local Funktionen  = {}

function Funktionen.Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Wither-Programm/" .. versionTyp .. "/Wither-Programm/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Wither-Programm/master/Wither-Programm/"
  end
end

function Funktionen.installieren(versionTyp)
  fs.makeDirectory("/update/wither/sprache")
  local updateKomplett = false
  local update = {}
  update[1] = wget("-f", Funktionen.Pfad(versionTyp) .. "autorun.lua",                   "/update/autorun.lua")
  update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/check.lua",              "/update/wither/check.lua")
  update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/version.txt",            "/update/wither/version.txt")
  update[4] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/wither.lua",             "/update/wither/wither.lua")
  update[5] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/sprache/deutsch.lua",    "/update/wither/sprache/deutsch.lua")
  update[6] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/sprache/english.lua",    "/update/wither/sprache/english.lua")
  update[7] = wget("-f", Funktionen.Pfad(versionTyp) .. "wither/sicherNachNeustart.lua", "/update/wither/sicherNachNeustart.lua")
  for i in pairs(update) do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. i)
      end
      local f = io.open ("/autorun.lua", "w")
      f:write('-- pastebin run -f j9duLPvp\n')
      f:write('-- von Nex4rius\n')
      f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Wither-Programm\n\n')
      f:write('local args = require("shell").parse(...)[1]\n\n')
      f:write('if type(args) == "string" then\n')
      f:write('  loadfile("/wither/check.lua")(args)\n')
      f:write('else\n')
      f:write('  loadfile("/wither/check.lua")()\n')
      f:write('end\n\n')
      f:close()
      break
    end
  end
  if updateKomplett then
    fs.makeDirectory("/wither/sprache")
    move("-f", "/update/autorun.lua",                "/autorun.lua")
    move("-f", "/update/wither/check.lua",           "/wither/check.lua")
    move("-f", "/update/wither/version.txt",         "/wither/version.txt")
    if fs.exists("/wither/Sicherungsdatei.lua") == false then
      move(    "/update/wither/Sicherungsdatei.lua", "/wither/Sicherungsdatei.lua")
    end
    move("-f", "/update/wither/sprache/deutsch.lua", "/wither/sprache/deutsch.lua")
    move("-f", "/update/wither/sprache/english.lua", "/wither/sprache/english.lua")
    f = io.open ("/wither/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/wither/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
  end
  print()
  loadfile("/bin/rm.lua")("-v", "/update")
  loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  --loadfile("/autorun.lua")("no")
  --os.exit()
  if updateKomplett then
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
  end
  os.sleep(2)
  require("computer").shutdown(true)
end

if versionTyp == nil then
  if type(arg) == "string" then
    Funktionen.installieren(arg)
  else
    Funktionen.installieren("master")
  end
else
  Funktionen.installieren(versionTyp)
end
