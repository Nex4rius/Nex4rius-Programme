-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local NEU       = require("shell").parse(...)[1]
local ALT       = {}
local Sicherung = {}
local sprachen  = {}

if type(NEU) == "table" then
  if require("filesystem").exists("/stargate/Sicherungsdatei.lua") then
    ALT = loadfile("/stargate/Sicherungsdatei.lua")()
  end
  if require("filesystem").exists("/stargate/sprache/" .. tostring(NEU.Sprache) .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. tostring(NEU.Sprache) .. ".lua")()
  elseif require("filesystem").exists("/stargate/sprache/" .. tostring(ALT.Sprache) .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. tostring(ALT.Sprache) .. ".lua")()
  else
    sprachen = loadfile("/stargate/sprache/deutsch.lua")()
  end
  if type(NEU.autoclosetime) == "number" or NEU.autoclosetime == false then Sicherung.autoclosetime = NEU.autoclosetime else Sicherung.autoclosetime = ALT.autoclosetime end
  if type(NEU.IDC)           == "string" then Sicherung.IDC          = NEU.IDC          else Sicherung.IDC          = ALT.IDC          end
  if type(NEU.RF)            == "boolean"then Sicherung.RF           = NEU.RF           else Sicherung.RF           = ALT.RF           end
  if type(NEU.Sprache)       == "string" then Sicherung.Sprache      = NEU.Sprache      else Sicherung.Sprache      = ALT.Sprache      end
  if type(NEU.side)          == "string" then Sicherung.side         = NEU.side         else Sicherung.side         = ALT.side         end
  if type(NEU.autoUpdate)    == "boolean"then Sicherung.autoUpdate   = NEU.autoUpdate   else Sicherung.autoUpdate   = ALT.autoUpdate   end
  if type(NEU.control)       == "string" then Sicherung.control      = NEU.control      else Sicherung.control      = ALT.control      end
  if type(NEU.installieren)  == "boolean"then Sicherung.installieren = NEU.installieren else Sicherung.installieren = ALT.installieren end
  local f = io.open ("/stargate/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f Dkt9dn4S\n')
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
  f:write('  control       = "' .. tostring(Sicherung.control)      .. '",\n\n')
  f:write(string.rep("-", 10)   .. tostring(sprachen.nichtsAendern) .. string.rep("-", 33) .. '\n\n')
  f:write('  installieren  = '  .. tostring(Sicherung.installieren) .. ',\n')
  f:write('}')
  f:close()
  return true
else
  return false
end
