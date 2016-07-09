-- pastebin run -f 1pbsaeCQ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local a = require("shell").parse(...)[1]

if type(a) == "string" then
  loadfile("/stargate/check.lua")(a)
else
  loadfile("/stargate/check.lua")()
end
