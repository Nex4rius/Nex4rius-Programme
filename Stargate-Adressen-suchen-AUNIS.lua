local sg = require("component").getPrimary("stargate")

do
    local g = require("component").getPrimary("gpu")
    g.setResolution(g.maxResolution())
end

local gefunden = 0
local letzte = ""
local i = 0
local f = {}
local alleZeichen = {
	"Sculptor",
	"Scorpius",
	"Centaurus",
	"Monoceros",
	"Pegasus",
	"Andromeda",
	"Serpens Caput",
	"Aries",
	"Libra",
	"Eridanus",
	"Leo Minor",
	"Hydra",
	"Sagittarius",
	"Sextans",
	"Scutum",
	"Pisces",
	"Virgo",
	"Bootes",
	"Auriga",
	"Corona Australis",
	"Gemini",
	"Leo",
	"Cetus",
	"Triangulum",
	"Aquarius",
	"Microscopium",
	"Equuleus",
	"Crater",
	"Perseus",
	"Cancer",
	"Norma",
	"Taurus",
	"Canis Minor",
	"Capricornus",
	"Lynx",
	"Orion",
	"Piscis Austrinus",
}

local function restliche_zeichen(...)
    local blockiert = {...}
    local rest = {}

    for _, zeichen in pairs(alleZeichen) do
        local dazu = true

        for _, block in pairs(blockiert) do
            if zeichen == block then
                dazu = false
                break
            end
        end

        if dazu then
            table.insert(rest, zeichen)
        end
    end

    return rest
end

function f.nacheinander()
    for _, A in pairs(alleZeichen) do
        for _, B in pairs(restliche_zeichen(A)) do
            for _, C in pairs(restliche_zeichen(A, B)) do
                for _, D in pairs(restliche_zeichen(A, B, C)) do
                    for _, E in pairs(restliche_zeichen(A, B, C, D)) do
                        for _, F in pairs(restliche_zeichen(A, B, C, D, E)) do
                            f.check({A, B, C, D, E, F})
                        end
                    end
                end
            end
        end
    end
end

function f.zufall()
    local menge = #alleZeichen
    local function a()
        return alleZeichen[math.random(1,menge)]
    end
    while true do
        for j = 0, 1000 do
            f.check({a(), a(), a(), a(), a(), a()})
        end
        os.sleep(1)
    end
end

function f.check(Adresse)
    i = i + 1
    local adresse_name = table.concat(Adresse, "\t")
    
    local ok, ergebnis = pcall(sg.getEnergyRequiredToDial, Adresse)
    if ok and ergebnis and type(ergebnis) == "table" then
        local gpu = require("component").getPrimary("gpu")
        gpu.setForeground(0xFF0000)
        gpu.setBackground(0x006633)
        print("\n" .. adresse_name .. " GEFUNDEN\n")
        local d = io.open("ergebnis_suche", "a")
        d:write(Adresse .. "\n")
        d:close ()
        gpu.setForeground(0xFFFFFF)
        gefunden = gefunden + 1
        letzte = letzte .. adresse_name
    else
        print(i, "Gefunden:", gefunden, "Prüfe Adresse:" , adresse_name, letzte)
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
