component = require("component")
sg = component.getPrimary("stargate")

alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

for i = 1, 36 do
  ersteStelle = alleZeichen[i]
  if sg.energyToDial(ersteStelle .. "9ZV-L0Y-SA") == nil then
    print(ersteStelle .. "9ZV-L0Y-SA ERROR")
  else
    print(ersteStelle .. "9ZV-L0Y-SA JAP")
  end
end
