local component = require("component")
local event = require("event")
local i = 0

local d = io.open("/log", "w")
local function lesen(i, ...)
  d:write(i .. ...)
  print(i .. ...)
end

while true do
  i = i + 1
  lesen(i, event.pull())
end
d:close()
