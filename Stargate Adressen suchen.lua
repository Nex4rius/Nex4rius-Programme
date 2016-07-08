local component = require("component")
local sg = component.getPrimary("stargate")
local gpu = component.getPrimary("gpu")

local alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

local f = io.open("ergebnis_suche", "w")
for Ai = 1, 36 do
  local A = alleZeichen[Ai]
  for Bi = 1, 36 do
    local B = alleZeichen[Bi]
    for Ci = 1, 36 do
      local C = alleZeichen[Ci]
      for Di = 1, 36 do
        local D = alleZeichen[Di]
        for Ei = 1, 36 do
          local E = alleZeichen[Ei]
          for Fi = 1, 36 do
            local F = alleZeichen[Fi]
            for Gi = 1, 36 do
              local G = alleZeichen[Gi]
              for Hi = 1, 36 do
                local H = alleZeichen[Hi]
                for Ii = 1, 36 do
                  local I = alleZeichen[Ii]
                  local Adresse = I .. H .. G .. F .. "-" .. E .. D .. C .. "-" .. B .. A
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
