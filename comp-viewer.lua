-- pastebin run P99QiVfG
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

local c = require("component")
local fs = require("filesystem")
local term = require("term")
local pfad = "temp-comp-viewer"
local alle = {}

local d = io.open(pfad, "w")

local function zeig(text)
  print(text)
  d:write(text)
end

for id, name in c.list() do
  zeig(string.format(">>> %s - %s <<<\n", name, id))
  alle[name] = true
end

d:write("\n\n")

local function zeig_method(name)
  for i in pairs(c.list(name)) do
    for j in pairs(c.methods(i)) do
      zeig("  " .. j .. "\n    " .. tostring(c.doc(i, j)) .. "\n")
    end
    zeig("\n\n")
  end
end

for id, name in c.list() do
  if alle[name] then
    zeig(string.format(">>> %s - %s <<<\n", name, id))
    zeig_method(name)
    alle[name] = false
  end
end

os.execute("edit " .. pfad)
fs.remove(pfad)
