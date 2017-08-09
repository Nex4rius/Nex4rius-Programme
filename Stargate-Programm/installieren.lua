-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

OC = nil
CC = nil
if require then
  OC = true
  require("shell").setWorkingDirectory("/")
else
  CC = true
end

local arg         = ...
local Sicherung   = {}
local Funktionen  = {}
local sprachen, IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate
local shell       = shell or require("shell")
_G.shell = shell
local fs          = fs or require("filesystem")
fs.makeDirectory  = fs.makeDirectory or fs.makeDir
local kopieren    = loadfile("/bin/cp.lua") or function(a, b, c)
  if type(a) == "string" and type(b) == "string" then
    if c == "-n" then
      fs.delete(b)
    end
    if fs.exists(a) and not fs.exists(b) then
      fs.copy(a, b)
    end
    return true
  end
end
local wget = loadfile("/bin/wget.lua") or function(option, url, ziel)
  if type(url) ~= "string" and type(ziel) ~= "string" then
    return
  elseif type(option) == "string" and option ~= "-f" and type(url) == "string" then
    ziel = url
    url = option
  end
  if http.checkURL(url) then
    if fs.exists(ziel) and option ~= "-f" then
      printError("<Fehler> Ziel existiert bereits")
      return
    else
      term.write("Starte Download ... ")
      local timer = os.startTimer(30)
      http.request(url)
      while true do
        local event, id, data = os.pullEvent()
        if event == "http_success" then
          print("erfolgreich")
          local f = io.open(ziel, "w")
          f:write(data.readAll())
          f:close()
          data:close()
          print("Gespeichert unter " .. ziel)
          return true
        elseif event == "timer" and timer == id then
          printError("<Fehler> Zeitueberschreitung")
          return
        elseif event == "http_failure" then
          printError("<Fehler> Download")
          os.cancelAlarm(timer)
          return
        end
      end
    end
  else
    printError("<Fehler> URL")
    return
  end
end

if not fs.exists("/einstellungen") then
  fs.makeDirectory("/einstellungen")
end
if not fs.exists("/einstellungen/adressen.lua") then
  if fs.exists("/stargate/adressen.lua") then
    kopieren("/stargate/adressen.lua", "/einstellungen/adressen.lua")
  end
end
if not fs.exists("/einstellungen/Sicherungsdatei.lua") then
  if fs.exists("/stargate/Sicherungsdatei.lua") then
    kopieren("/stargate/Sicherungsdatei.lua", "/einstellungen/Sicherungsdatei.lua")
  end
end

if fs.exists("/einstellungen/Sicherungsdatei.lua") then
  Sicherung = loadfile("/einstellungen/Sicherungsdatei.lua")()
  if type(Sicherung) == "string" then
    Sicherung = {}
    Sicherung.IDC, Sicherung.autoclosetime, Sicherung.RF, Sicherung.Sprache, Sicherung.side, Sicherung.installieren, Sicherung.control, Sicherung.autoUpdate = loadfile("/einstellungen/Sicherungsdatei.lua")()
  end
else
  Sicherung.Sprache = ""
  Sicherung.installieren = false
end

local Sprachliste = {"deutsch", "english", "russian", "czech", Sicherung.Sprache}

if Sicherung.Sprache then
  if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  end
end

function Funktionen.Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Stargate-Programm/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Stargate-Programm/"
  end
end

function Funktionen.schreibAutorun()
  local f = io.open("/autorun.lua", "w")
  f:write([[
  -- pastebin run -f YVqKFnsP
  -- von Nex4rius
  -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

  local shell = shell or require("shell")
  local alterPfad
  local args = ...
  
  if require then
      alterPfad = shell.getWorkingDirectory()
      shell.setWorkingDirectory("/")
  end
  
  if type(args) ~= "string" then
      args = nil
  end
  
  local ergebnis, grund = pcall(loadfile("/stargate/check.lua"), args)
  if not ergebnis then
      print("<Fehler>")
      print(grund)
      os.sleep(2)
      if require then
          if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Stargate-Programm/installieren.lua", "/installieren.lua") then
              loadfile("/installieren.lua")()
          end
      else
          shell.run("pastebin run -f YVqKFnsP")
      end
  end
  
  if require then
      require("shell").setWorkingDirectory(alterPfad)
  end
  ]])
  f:close()
end

function Funktionen.installieren(versionTyp)
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local update = {}
  update[1] = wget("-f", Funktionen.Pfad(versionTyp) .. "autorun.lua",                        "/update/autorun.lua")
  update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/check.lua",                 "/update/stargate/check.lua")
  update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/version.txt",               "/update/stargate/version.txt")
  update[4] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/adressen.lua",              "/update/stargate/adressen.lua")
  update[5] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/Sicherungsdatei.lua",       "/update/stargate/Sicherungsdatei.lua")
  update[6] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/Kontrollprogramm.lua",      "/update/stargate/Kontrollprogramm.lua")
  update[7] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/schreibSicherungsdatei.lua","/update/stargate/schreibSicherungsdatei.lua")
  update[8] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  for s in pairs(Sprachliste) do
    if Sprachliste[s] ~= "" then
      if wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/" .. Sprachliste[s] .. ".lua", "/update/stargate/sprache/" .. Sprachliste[s] .. ".lua") then
        update[9] = true
      end
    end
  end
  for i = 1, 9 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      end
      Funktionen.schreibAutorun()
      break
    end
  end
  if updateKomplett then
    fs.makeDirectory("/stargate/sprache")
    if OC then
      kopieren("/update/autorun.lua",                       "/autorun.lua")
    elseif CC then
      kopieren("/update/autorun.lua",                       "/startup")
    end
    kopieren("/update/stargate/check.lua",                  "/stargate/check.lua")
    kopieren("/update/stargate/version.txt",                "/stargate/version.txt")
    if fs.exists("/stargate/adressen.lua") == false then
      kopieren("/update/stargate/adressen.lua",             "/stargate/adressen.lua", "-n")
    end
    if fs.exists("/stargate/Sicherungsdatei.lua") == false then
      kopieren("/update/stargate/Sicherungsdatei.lua",      "/stargate/Sicherungsdatei.lua", "-n")
    end
    kopieren("/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    kopieren("/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    kopieren("/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    for s in pairs(Sprachliste) do
      if Sprachliste[s] ~= "" then
        kopieren("/update/stargate/sprache/" .. Sprachliste[s] .. ".lua", "/stargate/sprache/" .. Sprachliste[s] .. ".lua")
      end
    end
    local f = io.open("/stargate/version.txt", "r")
    if f then
      version = f:read()
      f:close()
      if versionTyp == "beta" then
        local f = io.open("/stargate/version.txt", "w")
        f:write(version .. " BETA")
        f:close()
      end
    end
    Sicherung.installieren = true
    loadfile("/stargate/schreibSicherungsdatei.lua")(Sicherung)
    print()
  end
  if OC then
    local f = io.open("/bin/stargate.lua", "w")
    f:write('-- pastebin run -f YVqKFnsP\n')
    f:write('-- von Nex4rius\n')
    f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n')
    f:write('\n')
    f:write('if not pcall(loadfile("/autorun.lua"), require("shell").parse(...)[1]) then\n')
    f:write('   os.execute("pastebin run -f YVqKFnsP"\n')
    --f:write('   loadfile("/bin/wget-lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua")\n')
    --f:write('   loadfile("/bin/github.lua")("Nex4rius", "Nex4rius-Programme", "master", "Stargate-Programm")\n')
    f:write('end\n')
    f:close()
  --elseif CC then
  --  local f = io.open("/start", "w")
  --  f:write('-- pastebin run -f YVqKFnsP\n')
  --  f:write('-- von Nex4rius\n')
  --  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n')
  --  f:write('\n')
  --  f:write('if not pcall(loadfile("/startup"), ...) then\n')
  --  f:write('   shell.run("pastebin run -f YVqKFnsP")\n')
  --  f:write('end\n')
  --  f:close()
  end
  if updateKomplett then
    if OC then
      loadfile("/bin/rm.lua")("-v", "/update", "-r")
      loadfile("/bin/rm.lua")("-v", "/installieren.lua")
    elseif CC then
      shell.run("delete /update")
      shell.run("delete /installieren.lua")
    end
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
  else
    print("\nERROR install / update failed\n")
    print("10s bis Neustart")
    os.sleep(10)
  end  
  --if _OSVERSION ~= "OpenOS 1.6.1" then
  --end
  if OC then
    require("computer").shutdown(true)
  elseif CC then
    os.reboot()
  end
end

if versionTyp == nil then
  if arg == "neu" then
    if OC then
      loadfile("/bin/rm.lua")("-v", "/stargate", "-r")
      loadfile("/bin/rm.lua")("-v", "/update", "-r")
      local f = io.open("/autorun.lua", "w")
      f:write([[
        -- pastebin run -f YVqKFnsP
        -- von Nex4rius
        -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm
        
        wget("-f", Funktionen.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
        loadfile("/installieren.lua")()
      ]])
    elseif CC then
      shell.run("delete /stargate")
      shell.run("delete /update")
      local f = io.open("/startup", "w")
      f:write([[
        -- pastebin run -f YVqKFnsP
        -- von Nex4rius
        -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm
        
        shell.run("pastebin run -f YVqKFnsP")
      ]])
    end
    f:close()
    Funktionen.installieren("master")
  elseif type(arg) == "string" then
    Funktionen.installieren(arg)
  else
    Funktionen.installieren("master")
  end
else
  Funktionen.installieren(versionTyp)
end
