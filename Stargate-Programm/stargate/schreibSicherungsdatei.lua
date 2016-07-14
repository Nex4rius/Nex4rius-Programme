-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local Sicherung = require("shell").parse(...)[1]
  
f = io.open ("/stargate/Sicherungsdatei.lua", "w")
f:write('-- pastebin run -f Dkt9dn4S\n')
f:write('-- von Nex4rius\n')
f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
f:write('-- to save press "Ctrl + S"\n')
f:write('-- to close press "Ctrl + W"\n--\n\n')
f:write('return {\n')
f:write('  IDC           = "' .. tostring(Sicherung.IDC) .. '", -- Iris Deactivation Code\n')
f:write('  autoclosetime = '  .. tostring(Sicherung.autoclosetime) .. ', -- in seconds -- false for no autoclose\n')
f:write('  RF            = '  .. tostring(Sicherung.RF) .. ', -- show energy in RF instead of EU\n')
f:write('  Sprache       = "' .. tostring(Sicherung.Sprache) .. '", -- deutsch / english\n')
f:write('  side          = "' .. tostring(Sicherung.side) .. '", -- bottom, top, back, front, right or left\n')
f:write('  autoUpdate    = '  .. tostring(Sicherung.autoUpdate) .. ', -- automatically updates the programm\n')
f:write('  control       = "' .. tostring(Sicherung.control) .. '",\n\n')
f:write(string.rep("-", 10) .. "don't change anything below" .. string.rep("-", 33) .. '\n\n')
f:write('  installieren  = '  .. tostring(Sicherung.installieren) .. ',\n')
f:write('}')
f:close()

return true
