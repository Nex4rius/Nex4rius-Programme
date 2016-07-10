-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local args = require("shell").parse(...)
local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate

if require("filesystem").exists("/stargate/Sicherungsdatei.lua") then
  IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
end

if args[1] ~= nil then IDC           = args[1] elseif IDC           == nil then IDC           = ""      end
if args[2] ~= nil then autoclosetime = args[2] elseif autoclosetime == nil then autoclosetime = 60      end
if args[3] ~= nil then RF            = args[3] elseif RF            == nil then RF            = false   end
if args[4] ~= nil then Sprache       = args[4] elseif Sprache       == nil then Sprache       = ""      end
if args[5] ~= nil then side          = args[5] elseif side          == nil then side          = "unten" end
if args[6] ~= nil then installieren  = args[6] elseif installieren  == nil then installieren  = false   end
if args[7] ~= nil then control       = args[7] elseif control       == nil then control       = "On"    end
if args[8] ~= nil then autoUpdate    = args[8] elseif autoUpdate    == nil then autoUpdate    = true   end

f = io.open ("/stargate/Sicherungsdatei.lua", "w")
f:write('-- pastebin run -f wLK1gCKt\n')
f:write('-- von Nex4rius\n')
f:write('-- https://github.com/Nex4rius/Stargate-Programm\n--\n')
f:write('-- to save press "Ctrl + S"\n')
f:write('-- to close press "Ctrl + W"\n--\n\n')
f:write('local IDC           = "' .. tostring(IDC) .. '" -- Iris Deactivation Code\n')
f:write('local autoclosetime = '  .. tostring(autoclosetime) .. ' -- in seconds -- false for no autoclose\n')
f:write('local RF            = '  .. tostring(RF) .. ' -- show energy in RF instead of EU\n')
f:write('local Sprache       = "' .. tostring(Sprache) .. '" -- deutsch / english\n')
f:write('local side          = "' .. tostring(side) .. '" -- bottom, top, back, front, right or left\n')
f:write('local autoUpdate    = '  .. tostring(autoUpdate) .. ' -- automatically updates the programm\n\n')
f:write(string.rep("-", 10) .. "don't change anything below" .. string.rep("-", 33) .. '\n\n')
f:write('local installieren  = '  .. tostring(installieren) .. '\n')
f:write('local control       = "' .. tostring(control) .. '"\n\n')
f:write(string.rep("-", 70) .. '\n\n')
f:write('if type(IDC) ~= "string" then\n  IDC = ""\nend\n')
f:write('if type(autoclosetime) ~= "number" then\n  autoclosetime = 60\nend\n')
f:write('if type(RF) ~= "boolean" then\n  RF = false\nend\n')
f:write('if type(Sprache) ~= "string" then\n  Sprache = ""\nend\n')
f:write('if type(side) ~= "string" then\n  side = "unten"\nend\n')
f:write('if type(installieren) ~= "boolean" then\n  installieren = false\nend\n')
f:write('if type(control) ~= "string" then\n  control = "On"\nend\n')
f:write('if type(autoUpdate) ~= "boolean" then\n  autoUpdate = true\nend\n\n')
f:write('return IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate\n')
f:close()

return true
