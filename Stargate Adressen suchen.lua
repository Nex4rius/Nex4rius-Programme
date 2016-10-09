local sg = require("component").getPrimary("stargate")

local alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

-- test
local function suchen(...)
  for i = 1, 36 do
    return alleZeichen[i]
  end
end

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
                    require("component").getPrimary("gpu").setForeground(0xFF0000)
                    print("\n" .. Adresse .. " GEFUNDEN\n")
                    f = io.open("ergebnis_suche", "a")
                    f:write(Adresse .. "\n")
                    f:close ()
                    require("component").getPrimary("gpu").setForeground(0xFFFFFF)
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
