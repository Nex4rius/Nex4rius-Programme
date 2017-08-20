local c = require("component")
local term = require("term")

term.clear()
term.write("Name der Komponente: ")

for i in pairs(c.list(io.read())) do
  for j in pairs(c.methods(i)) do
    print(j)
    print(c.doc(i, j)
    print()
  end
end
