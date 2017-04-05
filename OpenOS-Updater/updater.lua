-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local fs            = require("filesystem")
local component     = require("component")
local term          = require("term")
local gpu           = component.gpu

local wget          = loadfile("/bin/wget.lua")
local kopieren      = loadfile("/bin/cp.lua")
local entfernen     = loadfile("/bin/rm.lua")

local Funktion      = {}

function Funktion.Pfad(api)
    if api then
        return "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/41acf2fa06990dcc4d740490cccd9d2bcec97edd?recursive=1"
    else
        return "https://raw.githubusercontent.com/MightyPirates/OpenComputers/master-MC1.7.10/src/main/resources/assets/opencomputers/loot/openos/"
    end
end

function Funktion.checkKomponenten()
    term.clear()
    local weiter = true
    print("Prüfe Komponenten\n")
    local function check(eingabe)
        if component.isAvailable(eingabe[1]) then
            gpu.setForeground(0x00FF00)
            print(eingabe[2])
        else
            gpu.setForeground(0xFF0000)
            print(eingabe[3])
            if eingabe[4] then
                weiter = false
            end
        end
    end
    local alleKomponenten = {
        {"internet", "- Internet             ok", "- Internet             fehlt", true},
        {"gpu",      "- GPU                  ok", "- GPU                  fehlt"},
    }
    for i in pairs(alleKomponenten) do
        check(alleKomponenten[i])
    end
    print()
    gpu.setForeground(0xFFFFFF)
    if not weiter then
        os.exit()
    end
end

function Funktion.verarbeiten()
    local f = io.open("/OpenOS-Updater/github-liste.txt", "r")
    local dateien = loadfile("/OpenOS-Updater/json.lua")():decode(f:read("*all"))
    f:close()
    fs.makeDirectory("/update")
    local komplett = true
    gpu.setForeground(0xFFFFFF)
    print("Starte Download")
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
        elseif dateien.tree[i].type == "blob" then
            if not wget("-f", Funktion.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
                komplett = false
            end
        end
    end
    print("Download Beendet")
    if dateien["truncated"] or not komplett then
        gpu.setForeground(0xFF0000)
        print("<FEHLER> Download unvollständig")
        entfernen("-rv", "/update")
        os.exit()
    else
        print("Ersetze alte Dateien")
        for i in fs.list("/update") do
            kopieren("-rv", "/update/" .. i, "/" .. i)
        end
        entfernen("-rv", "/update")
        gpu.setForeground(0x00FF00)
        print("Update vollständig")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    Funktion.checkKomponenten()
    fs.makeDirectory("/OpenOS-Updater")
    if wget("-f", Funktion.Pfad(true), "/OpenOS-Updater/github-liste.txt") then
        if Funktion.verarbeiten() then
            return
        end
    end
    gpu.setForeground(0xFF0000)
    print("<FEHLER> GitHub Download")
end

if not pcall(main) then
    gpu.setForeground(0xFF0000)
    print("<FEHLER> Funktion main")
end

gpu.setForeground(0xFFFFFF)
