-- pastebin run -f 1pbsaeCQ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local args = require("shell").parse(...)

if type(args[1]) == "string" then
  args[1] = string.lower(args[1])
else
  args[1] = ""
end

loadfile("/stargate/check.lua")(args[1])
