-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm

local SicherungNEU = require("shell").parse(...)[1]
local SicherungALT = {}

if require("filesystem").exists("/stargate/Sicherungsdatei.lua") then
  SicherungALT = loadfile("/stargate/Sicherungsdatei.lua")()
end

if type(SicherungNEU) ~= "table" then
  SicherungNEU = {}
end

if SicherungNEU.IDC          == nil and SicherungALT.IDC          ~= nil then SicherungNEU.IDC          = SicherungALT.IDC           else SicherungNEU.IDC           = ""      end
if SicherungNEU.RF           == nil and SicherungALT.RF           ~= nil then SicherungNEU.RF           = SicherungALT.RF            else SicherungNEU.RF            = false   end
if SicherungNEU.side         == nil and SicherungALT.side         ~= nil then SicherungNEU.side         = SicherungALT.side          else SicherungNEU.side          = "unten" end
if SicherungNEU.Sprache      == nil and SicherungALT.Sprache      ~= nil then SicherungNEU.Sprache      = SicherungALT.Sprache       else SicherungNEU.Sprache       = ""      end
if SicherungNEU.autoUpdate   == nil and SicherungALT.autoUpdate   ~= nil then SicherungNEU.autoUpdate   = SicherungALT.autoUpdate    else SicherungNEU.autoUpdate    = true    end
if SicherungNEU.autoclosetime== nil and SicherungALT.autoclosetime~= nil then SicherungNEU.autoclosetime= SicherungALT.autoclosetime else SicherungNEU.autoclosetime = 60      end
if SicherungNEU.control      == nil and SicherungALT.control      ~= nil then SicherungNEU.control      = SicherungALT.control       else SicherungNEU.control       = "On"    end
if SicherungNEU.installieren == nil and SicherungALT.installieren ~= nil then SicherungNEU.installieren = SicherungALT.installieren  else SicherungNEU.installieren  = false   end
  
f = io.open ("/stargate/Sicherungsdatei.lua", "w")
f:write('-- pastebin run -f wLK1gCKt\n')
f:write('-- von Nex4rius\n')
f:write('-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm\n--\n')
f:write('-- to save press "Ctrl + S"\n')
f:write('-- to close press "Ctrl + W"\n--\n\n')
f:write('return {\n')
f:write('  IDC           = "' .. tostring(SicherungNEU.IDC) .. '" -- Iris Deactivation Code\n')
f:write('  autoclosetime = '  .. tostring(SicherungNEU.autoclosetime) .. ' -- in seconds -- false for no autoclose\n')
f:write('  RF            = '  .. tostring(SicherungNEU.RF) .. ' -- show energy in RF instead of EU\n')
f:write('  Sprache       = "' .. tostring(SicherungNEU.Sprache) .. '" -- deutsch / english\n')
f:write('  side          = "' .. tostring(SicherungNEU.side) .. '" -- bottom, top, back, front, right or left\n')
f:write('  autoUpdate    = '  .. tostring(SicherungNEU.autoUpdate) .. ' -- automatically updates the programm\n\n')
f:write('  control       = "' .. tostring(SicherungNEU.control) .. '"\n\n')
f:write(string.rep("-", 10) .. "don't change anything below" .. string.rep("-", 33) .. '\n\n')
f:write('  installieren  = '  .. tostring(SicherungNEU.installieren) .. '\n')
f:write('}')
f:close()
