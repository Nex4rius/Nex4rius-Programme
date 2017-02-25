-- pastebin run -f 5Rpn3MZb
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

local args = require("shell").parse(...)[1]

if type(args) == "table" then
  args = ""
end

loadfile("/ic2crops.lua")(args)
