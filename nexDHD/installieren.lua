-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD

OC = nil
CC = nil
if require then
  OC = true
  require("shell").setWorkingDirectory("/")
else
  CC = true
  local monitor = peripheral.find("monitor")
  if not monitor then
    print("keinen >Advanced Monitor< gefunden")
  end
  term.redirect(monitor)
  term.clear()
  monitor.setTextScale(0.5)
  monitor.setCursorPos(1, 1)
end

local arg         = ...
local Sicherung   = {}
local f           = {}
local sprachen, IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate
local shell       = shell or require("shell")
_G.shell = shell
local fs          = fs or require("filesystem")
fs.makeDirectory  = fs.makeDirectory or fs.makeDir
local kopieren    = loadfile("/bin/cp.lua") or function(a, b, c)
  if type(a) == "string" and type(b) == "string" then
    if c ~= "-n" then
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
          local d = io.open(ziel, "w")
          d:write(data.readAll())
          d:close()
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

local Sprachliste = {"deutsch", "english", "russian", "czech"}
do
  local dazu = true
  for i in pairs(Sprachliste) do
    if Sprachliste[i] == Sicherung.Sprache then
      dazu = false
    end
  end
  if dazu then
    table.insert(Sprachliste, Sicherung.Sprache)
  end
end

if Sicherung.Sprache then
  if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  end
end

function f.Pfad(versionTyp)
  if versionTyp == "beta" then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/nexDHD/nexDHD/"
  elseif versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/nexDHD/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/nexDHD/"
  end
end

function f.schreibAutorun()
  local d = io.open("/autorun.lua", "w")
  d:write([[
  -- pastebin run -f YVqKFnsP
  -- nexDHD von Nex4rius
  -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD

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
          if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/nexDHD/installieren.lua", "/installieren.lua") then
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
  d:close()
end

function f.installieren(versionTyp)
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local function download(von, nach)
    for j = 1, 10 do
      if wget("-f", f.Pfad(versionTyp) .. von, nach) then
        return true
      elseif require("component").isAvailable("internet") then
        print(von .. "\nerneuter Downloadversuch in " .. j .. "s\n")
        os.sleep(j)
      else
        return
      end
    end
  end
  local anzahl = 0
  local update = {}
  local dateien = {
    {"autorun.lua",                         "/update/autorun.lua"},
    {"stargate/check.lua",                  "/update/stargate/check.lua"},
    {"stargate/version.txt",                "/update/stargate/version.txt"},
    {"stargate/adressen.lua",               "/update/stargate/adressen.lua"},
    {"stargate/Sicherungsdatei.lua",        "/update/stargate/Sicherungsdatei.lua"},
    {"stargate/Kontrollprogramm.lua",       "/update/stargate/Kontrollprogramm.lua"},
    {"stargate/schreibSicherungsdatei.lua", "/update/stargate/schreibSicherungsdatei.lua"},
    {"stargate/sprache/ersetzen.lua",       "/update/stargate/sprache/ersetzen.lua"},
  }
  for k, v in pairs(dateien) do
    update[k] = download(v[1], v[2])
    anzahl = k
  end
  for s in pairs(Sprachliste) do
    if Sprachliste[s] ~= "" then
      if wget("-f", f.Pfad(versionTyp) .. "stargate/sprache/" .. Sprachliste[s] .. ".lua", "/update/stargate/sprache/" .. Sprachliste[s] .. ".lua") then
        update[anzahl + 1] = true
      end
    end
  end
  for i = 1, anzahl + 1 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      end
      f.schreibAutorun()
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
    kopieren("/update/stargate/adressen.lua",               "/stargate/adressen.lua")
    kopieren("/update/stargate/Sicherungsdatei.lua",        "/stargate/Sicherungsdatei.lua")
    kopieren("/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    kopieren("/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    kopieren("/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    for s in pairs(Sprachliste) do
      if Sprachliste[s] ~= "" then
        kopieren("/update/stargate/sprache/" .. Sprachliste[s] .. ".lua", "/stargate/sprache/" .. Sprachliste[s] .. ".lua")
      end
    end
    local d = io.open("/stargate/version.txt", "r")
    if f then
      version = d:read()
      d:close()
      if versionTyp == "beta" then
        local d = io.open("/stargate/version.txt", "w")
        d:write(version .. " BETA")
        d:close()
      end
    end
    Sicherung.installieren = true
    loadfile("/stargate/schreibSicherungsdatei.lua")(Sicherung)
    print()
  end
  if OC then
    kopieren("/autorun.lua", "/bin/nexDHD.lua")
    kopieren("/autorun.lua", "/bin/stargate.lua")
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
      local d = io.open("/autorun.lua", "w")
      d:write([[
        -- pastebin run -f YVqKFnsP
        -- nexDHD von Nex4rius
        -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD
        
        wget("-f", f.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
        loadfile("/installieren.lua")()
      ]])
    elseif CC then
      shell.run("delete /stargate")
      shell.run("delete /update")
      local d = io.open("/startup", "w")
      d:write([[
        -- pastebin run -f YVqKFnsP
        -- nexDHD von Nex4rius
        -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD
        
        shell.run("pastebin run -f YVqKFnsP")
      ]])
    end
    d:close()
    f.installieren("master")
  elseif type(arg) == "string" then
    f.installieren(arg)
  else
    f.installieren("master")
  end
else
  f.installieren(versionTyp)
end
