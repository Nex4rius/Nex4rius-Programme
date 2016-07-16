-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local SicherungNEU = require("shell").parse(...)[1]
local SicherungALT = loadfile("/stargate/Sicherungsdatei.lua")()

if type(SicherungNEU) == "table" then
  local f = io.open ("/stargate/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f Dkt9dn4S\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n\n')
  f:write('return {\n')
  if type(SicherungNEU.IDC) == "string" then
    f:write('  IDC           = "' .. tostring(SicherungNEU.IDC) .. '", -- Iris Deactivation Code\n')
  else
    f:write('  IDC           = "' .. tostring(SicherungALT.IDC) .. '", -- Iris Deactivation Code\n')
  end
  if type(SicherungNEU.autoclosetime) == "number" or SicherungNEU.autoclosetime == false then
    f:write('  autoclosetime = '  .. tostring(SicherungNEU.autoclosetime) .. ', -- in seconds -- false for no autoclose\n')
  else
    f:write('  autoclosetime = '  .. tostring(SicherungALT.autoclosetime) .. ', -- in seconds -- false for no autoclose\n')
  end
  if type(SicherungNEU.RF) == "boolean" then
    f:write('  RF            = '  .. tostring(SicherungNEU.RF) .. ', -- show energy in RF instead of EU\n')
  else
    f:write('  RF            = '  .. tostring(SicherungALT.RF) .. ', -- show energy in RF instead of EU\n')
  end
  if type(SicherungNEU.Sprache) == "string" then
    f:write('  Sprache       = "' .. tostring(SicherungNEU.Sprache) .. '", -- deutsch / english\n')
  else
    f:write('  Sprache       = "' .. tostring(SicherungALT.Sprache) .. '", -- deutsch / english\n')
  end
  if type(SicherungNEU.side) == "string" then
    f:write('  side          = "' .. tostring(SicherungNEU.side) .. '", -- bottom, top, back, front, right or left\n')
  else
    f:write('  side          = "' .. tostring(SicherungALT.side) .. '", -- bottom, top, back, front, right or left\n')
  end
  if type(SicherungNEU.autoUpdate) == "boolean" then
    f:write('  autoUpdate    = '  .. tostring(SicherungNEU.autoUpdate) .. ', -- automatically updates the programm\n')
  else
    f:write('  autoUpdate    = '  .. tostring(SicherungALT.autoUpdate) .. ', -- automatically updates the programm\n')
  end
  if type(SicherungNEU.control) == "string" then
    f:write('  control       = "' .. tostring(SicherungNEU.control) .. '",\n\n')
  else
    f:write('  control       = "' .. tostring(SicherungALT.control) .. '",\n\n')
  end
  f:write(string.rep("-", 10) .. "don't change anything below" .. string.rep("-", 33) .. '\n\n')
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
