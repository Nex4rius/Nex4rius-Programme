component = require("component")
sg = component.getPrimary("stargate")
gpu = component.getPrimary("gpu")

alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

for Ai = 1, 36 do
  neunteStelle = alleZeichen[Ai]
  for Bi = 1, 36 do
    achteStelle = alleZeichen[Bi]
    for Ci = 1, 36 do
      siebteStelle = alleZeichen[Ci]
      for Di = 1, 36 do
        sechsteStelle = alleZeichen[Di]
        for Ei = 1, 36 do
          fuenfteStelle = alleZeichen[Ei]
          for Fi = 1, 36 do
            vierteStelle = alleZeichen[Fi]
            for Gi = 1, 36 do
              dritteStelle = alleZeichen[Gi]
              for Hi = 1, 36 do
                zweiteStelle = alleZeichen[Hi]
                for Ii = 1, 36 do
                  ersteStelle = alleZeichen[Ii]
                  if sg.energyToDial(ersteStelle .. "ZV-L0Y-SA") == nil then
                    print(ersteStelle .. zweiteStelle .. dritteStelle .. vierteStelle .. "-" .. fuenfteStelle .. sechsteStelle .. siebteStelle .. "-" .. achteStelle .. neunteStelle)
                  else
                    gpu.setForeground(0xFF0000)
                    print("")
                    print(ersteStelle .. zweiteStelle .. dritteStelle .. vierteStelle .. "-" .. fuenfteStelle .. sechsteStelle .. siebteStelle .. "-" .. achteStelle .. neunteStelle .. " GEFUNDEN")
                    print("")
                    gpu.setForeground(0xFFFFFF)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
