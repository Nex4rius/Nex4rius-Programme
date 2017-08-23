-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD

local fs        = fs or require("filesystem")
local NEU       = ...
local ALT       = loadfile("/einstellungen/Sicherungsdatei.lua")
local standard  = loadfile("/stargate/Sicherungsdatei.lua")
local Sicherung = {}
local sprachen  = {}

if type(ALT) == "function" then AlT = ALT() end
if type(ALT) ~= "table" then ALT = {} end

if standard then
  standard = standard()
else
  standard = {autoclosetime = 60, IDC = "", RF = false, Sprache = "", side = "unten", autoUpdate = true, StargateName = "", Port = 800, debug = false, control = "On", installieren = false}
end

local function reset()
  return {
    speichern      = 'zum speichern drücke "Strg + S"',
    schliessen     = 'zum schließen drücke "Strg + W"',
    autoclosetime  = "in Sekunden -- false für keine automatische Schließung",
    IDC            = "Iris Deaktivierungscode",
    RF             = "zeige Energie in RF anstatt in EU",
    Sprache        = "deutsch / english / russian / czech",
    side           = "unten, oben, hinten, vorne, rechts oder links",
    autoUpdate     = "aktiviere automatische Aktualisierungen",
    Port           = "standard 800",
    debug          = "zum debuggen",
    nichtsAendern  = "verändere nichts ab hier",
    StargateName   = "der Name dieses Stargates",
  }
end

if type(NEU) == "table" then
  sprachen = loadfile("/stargate/sprache/" .. tostring(NEU.Sprache) .. ".lua") or loadfile("/stargate/sprache/" .. tostring(ALT.Sprache) .. ".lua") or loadfile("/stargate/sprache/deutsch.lua") or reset
  local _, sprachen = pcall(sprachen)
  if type(sprachen) ~= "table" then
    sprachen = reset()
  end
    
  if type(NEU.autoclosetime) == "number" or NEU.autoclosetime == false then
    Sicherung.autoclosetime = NEU.autoclosetime
  elseif type(ALT.autoclosetime) == "number" or ALT.autoclosetime == false then
    Sicherung.autoclosetime = ALT.autoclosetime
  else
    Sicherung.autoclosetime = standard.autoclosetime
  end
    
  local function check(typ, name)
    if type(NEU[name]) == typ then
      Sicherung[name] = NEU[name]
    elseif type(ALT[name]) == typ then
      Sicherung[name] = ALT[name] 
    else
      Sicherung[name] = standard[name]
    end
  end
  check("string" , "StargateName")
  check("string" , "IDC")
  check("boolean", "RF")
  check("string" , "Sprache")
  check("string" , "side")
  check("boolean", "autoUpdate")
  check("number" , "Port")
  check("boolean", "debug")
  check("string" , "control")
  check("boolean", "installieren")
  
  local f = io.open ("/einstellungen/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- nexDHD von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD\n--\n')
  f:write('-- ' .. tostring(sprachen.speichern) .. '\n')
  f:write('-- ' .. tostring(sprachen.schliessen) .. '\n--\n\n')
  f:write('return {\n')
  if Sicherung.autoclosetime then
    f:write('  autoclosetime = '  .. tostring(Sicherung.autoclosetime)..  ', -- ' .. tostring(sprachen.autoclosetime) .. '\n')
  else
    f:write('  autoclosetime = false, -- ' .. tostring(sprachen.autoclosetime) .. '\n')
  end
  f:write('  IDC           = "' .. tostring(Sicherung.IDC)          .. '", -- ' .. tostring(sprachen.IDC)           .. '\n')
  f:write('  RF            = '  .. tostring(Sicherung.RF)           ..  ', -- ' .. tostring(sprachen.RF)            .. '\n')
  f:write('  Sprache       = "' .. tostring(Sicherung.Sprache)      .. '", -- deutsch / english / russian / czech\n')
  f:write('  side          = "' .. tostring(Sicherung.side)         .. '", -- ' .. tostring(sprachen.side)          .. '\n')
  f:write('  autoUpdate    = '  .. tostring(Sicherung.autoUpdate)   ..  ', -- ' .. tostring(sprachen.autoUpdate)    .. '\n')
  f:write('  StargateName  = "' .. tostring(Sicherung.StargateName) .. '", -- ' .. tostring(sprachen.StargateName)  .. '\n')
  f:write('  Port          = '  .. tostring(Sicherung.Port)         ..  ', -- ' .. tostring(sprachen.Port)          .. '\n')
  f:write('\n')
  f:write(string.rep("-", 10)   .. tostring(sprachen.nichtsAendern) .. string.rep("-", 60 - string.len(tostring(sprachen.nichtsAendern))) .. '\n')
  f:write('\n')
  f:write('  debug         = '  .. tostring(Sicherung.debug)        .. ',  -- ' .. tostring(sprachen.debug)         .. '\n')
  f:write('  control       = "' .. tostring(Sicherung.control)      .. '",\n')
  f:write('  installieren  = '  .. tostring(Sicherung.installieren) .. ',\n')
  f:write('}')
  f:close()
  return true
end
