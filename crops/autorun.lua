-- pastebin run -f XXXXXXXX
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/crops

local args = require("shell").parse(...)[1]

if type(args) == "table" then
  args = ""
end

loadfile("/crops/check.lua")(args)
