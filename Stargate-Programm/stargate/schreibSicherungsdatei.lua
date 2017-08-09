-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local fs        = fs or require("filesystem")
local NEU       = ...
local ALT       = loadfile("/einstellungen/Sicherungsdatei.lua")
local standard  = loadfile("/stargate/Sicherungsdatei.lua")
local Sicherung = {}
local sprachen  = {}

if type(ALT) == "function" then
  AlT = ALT()
end
if type(ALT) ~= "table" then
  ALT = {}
end

if standard then
  standard = standard()
else
  standard = {autoclosetime = 60, IDC = "", RF = false, Sprache = "", side = "unten", autoUpdate = true, StargateName = "", debug = false, control = "On", installieren = false}
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
  check("boolean", "debug")
  check("string" , "control")
  check("boolean", "installieren")
  --if type(NEU.StargateName)  == "string" then Sicherung.StargateName = NEU.StargateName elseif type(ALT.StargateName) == "string" then Sicherung.StargateName = ALT.StargateName else Sicherung.StargateName = standard.StargateName end
  --if type(NEU.IDC)           == "string" then Sicherung.IDC          = NEU.IDC          elseif type(ALT.IDC)          == "string" then Sicherung.IDC          = ALT.IDC          else Sicherung.IDC          = standard.IDC          end
  --if type(NEU.RF)            == "boolean"then Sicherung.RF           = NEU.RF           elseif type(ALT.RF)           == "boolean"then Sicherung.RF           = ALT.RF           else Sicherung.RF           = standard.RF           end
  --if type(NEU.Sprache)       == "string" then Sicherung.Sprache      = NEU.Sprache      elseif type(ALT.Sprache)      == "string" then Sicherung.Sprache      = ALT.Sprache      else Sicherung.Sprache      = standard.Sprache      end
  --if type(NEU.side)          == "string" then Sicherung.side         = NEU.side         elseif type(ALT.side)         == "string" then Sicherung.side         = ALT.side         else Sicherung.side         = standard.side         end
  --if type(NEU.autoUpdate)    == "boolean"then Sicherung.autoUpdate   = NEU.autoUpdate   elseif type(ALT.autoUpdate)   == "boolean"then Sicherung.autoUpdate   = ALT.autoUpdate   else Sicherung.autoUpdate   = standard.autoUpdate   end
  --if type(NEU.debug)         == "boolean"then Sicherung.debug        = NEU.debug        elseif type(ALT.debug)        == "boolean"then Sicherung.debug        = ALT.debug        else Sicherung.debug        = standard.debug        end
  --if type(NEU.control)       == "string" then Sicherung.control      = NEU.control      elseif type(ALT.control)      == "string" then Sicherung.control      = ALT.control      else Sicherung.control      = standard.control      end
  --if type(NEU.installieren)  == "boolean"then Sicherung.installieren = NEU.installieren elseif type(ALT.installieren) == "boolean"then Sicherung.installieren = ALT.installieren else Sicherung.installieren = standard.installieren end
    
  local f = io.open ("/einstellungen/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
  f:write('-- ' .. tostring(sprachen.speichern) .. '\n')
  f:write('-- ' .. tostring(sprachen.schliessen) .. '\n--\n\n')
  f:write('return {\n')
  f:write('  autoclosetime = '  .. tostring(Sicherung.autoclosetime)..  ', -- ' .. tostring(sprachen.autoclosetime) .. '\n')
  f:write('  IDC           = "' .. tostring(Sicherung.IDC)          .. '", -- ' .. tostring(sprachen.IDC)           .. '\n')
  f:write('  RF            = '  .. tostring(Sicherung.RF)           ..  ', -- ' .. tostring(sprachen.RF)            .. '\n')
  f:write('  Sprache       = "' .. tostring(Sicherung.Sprache)      .. '", -- ' .. tostring(sprachen.Sprache)       .. '\n')
  f:write('  side          = "' .. tostring(Sicherung.side)         .. '", -- ' .. tostring(sprachen.side)          .. '\n')
  f:write('  autoUpdate    = '  .. tostring(Sicherung.autoUpdate)   ..  ', -- ' .. tostring(sprachen.autoUpdate)    .. '\n')
  f:write('  StargateName  = "' .. tostring(Sicherung.StargateName) .. '", -- ' .. tostring(sprachen.StargateName)  .. '\n')
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
