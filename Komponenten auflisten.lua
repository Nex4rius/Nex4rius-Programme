local i = 1

for k,v in require("component").list() do
  print(i, k, v)
  i = i + 1
end
