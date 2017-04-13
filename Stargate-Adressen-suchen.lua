local sg = require("component").getPrimary("stargate")

local A, B, C, D, E, F, G, H, I
local alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

local function nacheinander()
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
                    check({A, B, C, D, E, F, G, H, I})
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

local function zufall()
  while true do
    local adresse = {}
    for i = 1, 7 do
      adresse[i] = alleZeichen[math.random(1,36)]
    end
    check(adresse)
  end
end

local function check(eingabe)
  local Adresse = table.concat(eingabe)
  if sg.energyToDial(Adresse) then
    require("component").getPrimary("gpu").setForeground(0xFF0000)
    print("\n" .. Adresse .. " GEFUNDEN\n")
    f = io.open("ergebnis_suche", "a")
    f:write(Adresse .. "\n")
    f:close ()
    require("component").getPrimary("gpu").setForeground(0xFFFFFF)
  else
    print(Adresse)
  end
end

local function main()
  print("1)Nacheinander oder 2)Zufall?")
  while true do
    local eingabe = io.read()
    if tostring(eingabe) == "1" then
      nacheinander()
      break
    elseif tostring(eingabe) == "2" then
      zufall()
      break
    end
  end
end

main()
