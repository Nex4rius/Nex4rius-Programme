local component = require("component")
local event = require("event")
local term = require("term")
local i = 0

component.getPrimary("modem").open(100)

local d = io.open("/log", "w")
local function lesen(...)
  for k, v in pairs({...}) do
    d:write(tostring(v) .. "   ")
    term.write(tostring(v) .. "   ")
  end
  print()
end

while true do
  i = i + 1
  local a, b, c, d, e, f, g, h = event.pull()
  lesen(i, a, b, c, d, e, f, g, h)
end
d:close()
