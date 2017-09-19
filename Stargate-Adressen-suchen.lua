local sg = require("component").getPrimary("stargate")

local gefunden = 0
local i = 0
local f = {}
local A, B, C, D, E, F, G, H
local alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

function f.nacheinander()
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
                    f.check({A, B, C, D, "-", E, F, G, "-", H, alleZeichen[Ii]})
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

function f.zufall()
  local j = 0
  while true do
    j = j + 1
    if j == 1000 then
      os.sleep(1)
      j = 0
    end
    f.check({alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], "-", alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], "-", alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)]})
  end
end

function f.check(eingabe)
  local Adresse = table.concat(eingabe)
  if sg.energyToDial(Adresse) then
    local gpu = require("component").getPrimary("gpu")
    gpu.setForeground(0xFF0000)
    gpu.setBackground(0x006633)
    print("\n" .. Adresse .. " GEFUNDEN\n")
    local d = io.open("ergebnis_suche", "a")
    d:write(Adresse .. "\n")
    d:close ()
    gpu.setForeground(0xFFFFFF)
    gefunden = gefunden + 1
  else
    print("Prüfe Adresse Nr.: " .. i, Adresse, "Gefunden: " .. gefunden)
  end
end

local function main()
  print("1) Nacheinander oder 2) Zufall?")
  while true do
    local eingabe = io.read()
    if tostring(eingabe) == "1" then
      f.nacheinander()
      break
    elseif tostring(eingabe) == "2" then
      f.zufall()
      break
    end
  end
end

main()
