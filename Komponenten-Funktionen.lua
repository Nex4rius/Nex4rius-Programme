local c = require("component")
local fs = require("filesystem")
local term = require("term")

local d = io.open("/tmp/alledaten", "w")

for k,v in require("component").list() do
  d:write(string.format("%s - %s\n", v, k))
  for i in pairs(c.list(v)) do
    for j in pairs(c.methods(i)) do
      d:write("\t" .. j .. "\n")
      d:write(c.doc(i, j) .. "\n")
    end
  end
end

os.execute("view /tmp/alledaten")
os.execute("del /tmp/alledaten")
