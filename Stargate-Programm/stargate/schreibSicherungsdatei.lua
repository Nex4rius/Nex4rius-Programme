-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local fs        = require("filesystem")
local NEU       = require("shell").parse(...)[1]
local ALT       = {}
local Sicherung = {}
local sprachen  = {}

local function reset()
  return {
    speichern      = 'zum speichern drücke "Strg + S"',
    schliessen     = 'zum schließen drücke "Strg + W"',
    autoclosetime  = "in Sekunden -- false für keine automatische Schließung",
    IDC            = "Iris Deaktivierungscode",
    RF             = "zeige Energie in RF anstatt in EU",
    Sprache        = "deutsch / english",
    side           = "unten, oben, hinten, vorne, rechts oder links",
    autoUpdate     = "aktiviere automatische Aktualisierungen",
    debug          = "zum debuggen",
    nichtsAendern  = "verändere nichts ab hier",
    StargateName   = "der Name dieses Stargates",
  }
end

if type(NEU) == "table" then
  if fs.exists("/einstellungen/Sicherungsdatei.lua") then
    ALT = loadfile("/einstellungen/Sicherungsdatei.lua")()
  end
  if fs.exists("/stargate/sprache/" .. tostring(NEU.Sprache) .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. tostring(NEU.Sprache) .. ".lua")()
  elseif fs.exists("/stargate/sprache/" .. tostring(ALT.Sprache) .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. tostring(ALT.Sprache) .. ".lua")()
  elseif fs.exists("/stargate/sprache/deutsch.lua") then
    sprachen = loadfile("/stargate/sprache/deutsch.lua")()
  else
    sprachen = reset()
  end
  if type(sprachen) ~= "table" then
    sprachen = reset()
  end
  if type(NEU.autoclosetime) == "number" or NEU.autoclosetime == false then Sicherung.autoclosetime = NEU.autoclosetime else Sicherung.autoclosetime = ALT.autoclosetime end
  if type(NEU.StargateName)  == "string" then Sicherung.StargateName = NEU.StargateName elseif type(ALT.StargateName) == "string" then Sicherung.StargateName = ALT.StargateName else Sicherung.StargateName = "" end
  if type(NEU.IDC)           == "string" then Sicherung.IDC          = NEU.IDC          else Sicherung.IDC          = ALT.IDC          end
  if type(NEU.RF)            == "boolean"then Sicherung.RF           = NEU.RF           else Sicherung.RF           = ALT.RF           end
  if type(NEU.Sprache)       == "string" then Sicherung.Sprache      = NEU.Sprache      else Sicherung.Sprache      = ALT.Sprache      end
  if type(NEU.side)          == "string" then Sicherung.side         = NEU.side         else Sicherung.side         = ALT.side         end
  if type(NEU.autoUpdate)    == "boolean"then Sicherung.autoUpdate   = NEU.autoUpdate   else Sicherung.autoUpdate   = ALT.autoUpdate   end
  if type(NEU.debug)         == "boolean"then Sicherung.debug        = NEU.debug        else Sicherung.debug        = ALT.debug        end
  if type(NEU.control)       == "string" then Sicherung.control      = NEU.control      else Sicherung.control      = ALT.control      end
  if type(NEU.installieren)  == "boolean"then Sicherung.installieren = NEU.installieren else Sicherung.installieren = ALT.installieren end
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
else
  return false
end
