local c = require("component")
local term = require("term")

for k,v in require("component").list() do
  term.clear()
  print(k, v)
  for i in pairs(c.list(v)) do
    for j in pairs(c.methods(i)) do
      print(j)
      print(c.doc(i, j))
    end
  end
  io.read()
end
