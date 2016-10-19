-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local args = require("shell").parse(...)[1]
local gpu = require("component").getPrimary("gpu")
local update

if type(args) == "table" then
  args = ""
end

local i = 0

while args do
  i = i + 1
  args, update = loadfile("/stargate/check.lua")(args)
  if i >= 5 then
    update(args)
    require("computer").shutdown(true)
  end
end

gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.setResolution(gpu.maxResolution())
os.exit()
