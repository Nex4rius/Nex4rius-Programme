-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")

shell.setWorkingDirectory("/")

local fs            = require("filesystem")
local component     = require("component")
local term          = require("term")
local gpu           = component.gpu

local wget          = loadfile("/bin/wget.lua")
--local kopieren      = function(von, nach) fs.copy(von, nach) print(string.format("%s → %s", von, nach)) end
local verschieben   = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", von, nach)) end
local entfernen     = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local Funktion      = {}

function Funktion.Pfad(api)
    if api then
        return "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/285f9c8fa60abf54dd6b199c895c9e07943c6d1d?recursive=1"
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
    local f = io.open("/github-liste.txt", "r")
    local dateien = loadfile("/json.lua")():decode(f:read("*all"))
    f:close()
    fs.makeDirectory("/update")
    local komplett = true
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
        end
    end
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "blob" then
            if not wget("-f", Funktion.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
                komplett = false
                break
            end
        end
    end
    print("\nDownload Beendet\n")
    if dateien["truncated"] or not komplett then
        gpu.setForeground(0xFF0000)
        print("<FEHLER> Download unvollständig")
        entfernen("/update")
        entfernen("/github-liste.txt")
        shell.setWorkingDirectory(alterPfad)
        os.exit()
    else
        print("Ersetze alte Dateien")
        local function kopieren(...)
            for i in fs.list(...) do
                if fs.isDirectory(i) then
                    kopieren(i)
                end
                verschieben("/update/" .. i, "/")
            end
        end
        kopieren("/update")
        entfernen("/update")
        entfernen("/github-liste.txt")
        entfernen("/updater.lua")
        entfernen("/json.lua")
        gpu.setForeground(0x00FF00)
        print("Update vollständig")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    Funktion.checkKomponenten()
    gpu.setForeground(0xFFFFFF)
    print("Starte Download")
    if wget("-f", Funktion.Pfad(true), "/github-liste.txt") and wget("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/OpenOS-Updater/json.lua", "/json.lua") then
        if Funktion.verarbeiten() then
            return
        end
    end
    gpu.setForeground(0xFF0000)
    print("<FEHLER> GitHub Download")
end

local ergebnis, grund = pcall(main)
if not ergebnis then
    gpu.setForeground(0xFF0000)
    print("<FEHLER> Funktion main")
    print(grund)
end

gpu.setForeground(0xFFFFFF)
