local sg = require("component").getPrimary("stargate")

do
  local g = require("component").getPrimary("gpu")
  g.setResolution(g.maxResolution())
end

local gefunden = 0
local i = 0
local f = {}
local alleZeichen = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

function f.nacheinander()
  for A = 1, 36 do
    for B = 1, 36 do
      for C = 1, 36 do
        for D = 1, 36 do
          for E = 1, 36 do
            for F = 1, 36 do
              for G = 1, 36 do
                for H = 1, 36 do
                  for I = 1, 36 do
                    f.check({alleZeichen[A], alleZeichen[B], alleZeichen[C], alleZeichen[D], "-", alleZeichen[E], alleZeichen[F], alleZeichen[G], "-", alleZeichen[H], alleZeichen[I]})
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
  while true do
    for j = 0, 1000 do
      i = i + 1
      f.check({alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], "-", alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)], "-", alleZeichen[math.random(1,36)], alleZeichen[math.random(1,36)]})
    end
    os.sleep(1)
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
    print("Nr.", i, "Prüfe Adresse:" , Adresse, "Gefunden:", gefunden)
  end
end

local function main()
  while true do
    print("1) Nacheinander oder 2) Zufall?")
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
