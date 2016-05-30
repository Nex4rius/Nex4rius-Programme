component = require("component")
sg = component.getPrimary("stargate")
gpu = component.getPrimary("gpu")

Local A = "0"
Local B = "0"
Local C = "0"
Local D = "0"
Local E = "0"
Local F = "0"
Local G = "0"
Local H = "0"
Local I = "0"

alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
               "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
               "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

f = io.open("ergebnis_suche", "w")
for Ai = 1, 36 do
  A = alleZeichen[Ai]
  for Bi = 1, 36 do
    B = alleZeichen[Bi]
    for Ci = 1, 36 do
      C = alleZeichen[Ci]
      for Di = 1, 36 do
        D = alleZeichen[Di]
        for Ei = 1, 36 do
          E = alleZeichen[Ei]
          for Fi = 1, 36 do
            F = alleZeichen[Fi]
            for Gi = 1, 36 do
              G = alleZeichen[Gi]
              for Hi = 1, 36 do
                H = alleZeichen[Hi]
                for Ii = 1, 36 do
                  I = alleZeichen[Ii]
                  Adresse = I .. H .. G .. F .. "-" .. E .. D .. C .. "-" .. B .. A
                  if sg.energyToDial(Adresse) == nil then
                    print(Adresse)
                  else
                    gpu.setForeground(0xFF0000)
                    print("\n" .. Adresse .. " GEFUNDEN\n")
                    f:write(Adresse .. "\n")
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
f:close ()
