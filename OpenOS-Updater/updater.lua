-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

--[[
loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua")
loadfile("/bin/github.lua")("MightyPirates", "OpenComputers", "master-MC1.7.10", "src/main/resources/assets/opencomputers/loot/openos/", "41acf2fa06990dcc4d740490cccd9d2bcec97edd")
--]]

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")

shell.setWorkingDirectory("/")

local fs            = require("filesystem")
local component     = require("component")
local computer      = require("computer")
local term          = require("term")
local gpu           = component.gpu
local x, y          = gpu.getResolution()
x                   = x - 35

local wget          = loadfile("/bin/wget.lua")
local verschieben   = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen     = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local disk          = component.proxy(fs.get("/").address)

local ersetzen, id

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

function Funktion.status()
    gpu.set(x, 1, string.rep(" ", 35))
    gpu.set(x, 2, string.format("   RAM: %.1fkB / %.1fkB%s", (computer.totalMemory() - computer.freeMemory()) / 1024, computer.totalMemory() / 1024, string.rep(" ", 35)))
    gpu.set(x, 3, string.rep(" ", 35))
    gpu.set(x, 4, string.format("   Energie: %.1f / %.1f%s", computer.energy(), computer.maxEnergy(), string.rep(" ", 35)))
    gpu.set(x, 5, string.rep(" ", 35))
    gpu.set(x, 6, string.format("   Speicher: %.1fkB / %.1fkB%s", disk.spaceUsed() / 1024, disk.spaceTotal() / 1024, string.rep(" ", 35)))
    gpu.set(x, 7, string.rep(" ", 35))
    gpu.set(x, 8, string.rep(" ", 35))
end

function Funktion.verarbeiten()
    local function kopieren(...)
        for i in fs.list(...) do
            Funktion.status()
            if fs.isDirectory(i) then
                kopieren(i)
            end
            verschieben("/update/" .. i, "/" .. i)
        end
    end
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
            local ergebnis, grund = wget("-f", Funktion.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path)
            Funktion.status()
            if not ergebnis then
                if grund == "failed opening file for writing: not enough space" then
                    gpu.setForeground(0xFFFFFF)
                    print("\n\n<FEHLER> Festplatte voll\n")
                    print("Ersetze Dateien sofort? [j/N]")
                    gpu.setForeground(0xFF0000)
                    print("Jedes Problem beim Download hat jetzt eine hohe Chance OpenOS zu zerstören.")
                    gpu.setForeground(0xFFFFFF)
                    term.write("Eingabe: ")
                    if ersetzen or string.lower(io.read()) == "j" then
                        ersetzen = true
                        print("Ersetze alte Dateien")
                        kopieren("/update")
                        if not wget("-f", Funktion.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
                            komplett = false
                            break
                        end
                    else
                        komplett = false
                        break
                    end
                else
                    komplett = false
                    break
                end
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
        gpu.setForeground(0xFFFFFF)
        return true
    else
        print("Ersetze alte Dateien")
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
    Funktion.status()
    print("Starte Download")
    id = require("event").timer(0.1, Funktion.status, math.huge)
    if wget("-f", Funktion.Pfad(true), "/github-liste.txt") and wget("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/OpenOS-Updater/json.lua", "/json.lua") then
        if Funktion.verarbeiten() then
            return
        end
    end
    gpu.setForeground(0xFF0000)
    print("<FEHLER> GitHub Download")
end

gpu.setForeground(0xFFFFFF)
local ergebnis, grund = pcall(main)
if not ergebnis then
    gpu.setForeground(0xFF0000)
    print("<FEHLER> Funktion main")
    print(grund)
end

require("event").cancel(id)
gpu.setForeground(0xFFFFFF)
