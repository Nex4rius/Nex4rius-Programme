-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local SicherungNEU  = require("shell").parse(...)[1]
local SicherungALT  = {}
local sprachen      = {}

if require("filesystem").exists("/stargate/Sicherungsdatei.lua") then
  SicherungALT = loadfile("/stargate/Sicherungsdatei.lua")()
end

if require("filesystem").exists("/stargate/sprache/" .. tostring(SicherungNEU.Sprache) .. ".lua") then
  sprachen = loadfile("/stargate/sprache/" .. tostring(SicherungNEU.Sprache) .. ".lua")()
elseif require("filesystem").exists("/stargate/sprache/" .. tostring(SicherungALT.Sprache) .. ".lua") then
  sprachen = loadfile("/stargate/sprache/" .. tostring(SicherungALT.Sprache) .. ".lua")()
else
  sprachen = loadfile("/stargate/sprache/deutsch.lua")()
end

if type(SicherungNEU) == "table" then
  local f = io.open ("/stargate/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f Dkt9dn4S\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
  f:write('-- ' .. sprachen.speichern .. '\n')
  f:write('-- ' .. sprachen.schliessen .. '\n--\n\n')
  f:write('return {\n')
  if type(SicherungNEU.IDC) == "string" then
    f:write('  IDC           = "' .. tostring(SicherungNEU.IDC) .. '", -- ' .. tostring(sprachen.iriscode) .. '\n')
  else
    f:write('  IDC           = "' .. tostring(SicherungALT.IDC) .. '", -- ' .. tostring(sprachen.iriscode) .. '\n')
  end
  if type(SicherungNEU.autoclosetime) == "number" or SicherungNEU.autoclosetime == false then
    f:write('  autoclosetime = '  .. tostring(SicherungNEU.autoclosetime) .. ', -- ' .. tostring(sprachen.autoclosetime) .. '\n')
  else
    f:write('  autoclosetime = '  .. tostring(SicherungALT.autoclosetime) .. ', -- ' .. tostring(sprachen.autoclosetime) .. '\n')
  end
  if type(SicherungNEU.RF) == "boolean" then
    f:write('  RF            = '  .. tostring(SicherungNEU.RF) .. ', -- ' .. tostring(sprachen.RF) .. '\n')
  else
    f:write('  RF            = '  .. tostring(SicherungALT.RF) .. ', -- ' .. tostring(sprachen.RF) .. '\n')
  end
  if type(SicherungNEU.Sprache) == "string" then
    f:write('  Sprache       = "' .. tostring(SicherungNEU.Sprache) .. '", -- ' .. tostring(sprachen.Sprache) .. '\n')
  else
    f:write('  Sprache       = "' .. tostring(SicherungALT.Sprache) .. '", -- ' .. tostring(sprachen.Sprache) .. '\n')
  end
  if type(SicherungNEU.side) == "string" then
    f:write('  side          = "' .. tostring(SicherungNEU.side) .. '", -- ' .. tostring(sprachen.side) .. '\n')
  else
    f:write('  side          = "' .. tostring(SicherungALT.side) .. '", -- ' .. tostring(sprachen.side) .. '\n')
  end
  if type(SicherungNEU.autoUpdate) == "boolean" then
    f:write('  autoUpdate    = '  .. tostring(SicherungNEU.autoUpdate) .. ', -- ' .. tostring(sprachen.autoUpdate) .. '\n')
  else
    f:write('  autoUpdate    = '  .. tostring(SicherungALT.autoUpdate) .. ', -- ' .. tostring(sprachen.autoUpdate) .. '\n')
  end
  if type(SicherungNEU.control) == "string" then
    f:write('  control       = "' .. tostring(SicherungNEU.control) .. '",\n\n')
  else
    f:write('  control       = "' .. tostring(SicherungALT.control) .. '",\n\n')
  end
  f:write(string.rep("-", 10) .. tostring.(sprachen.nichtsAendern) .. string.rep("-", 33) .. '\n\n')
  if type(SicherungNEU.installieren) == "boolean" then
    f:write('  installieren  = '  .. tostring(SicherungNEU.installieren) .. ',\n')
  else
    f:write('  installieren  = '  .. tostring(SicherungALT.installieren) .. ',\n')
  end
  f:write('}')
  f:close()
  return true
else
  return false
end
