component = require("component")
sg = component.getPrimary("stargate")

alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

for i = 1, 36 do
  if sg.energyToDial(alleZeichen[i] .. "9ZV-L0Y-SA") == nil then
    print(alleZeichen[i] .. "9ZV-L0Y-SA ERROR")
  else
    print(alleZeichen[i] .. "9ZV-L0Y-SA JAP")
  end
end
