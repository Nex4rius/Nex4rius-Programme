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
local event         = require("event")
local gpu           = component.gpu
local disk          = component.proxy(fs.get("/").address)
local x, y          = gpu.getResolution()

local verschieben   = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen     = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local wget          = loadfile("/bin/wget.lua")


local Funktion      = {}

local ersetzen, id

x = x - 35

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
    gpu.set(x, 4, string.format("   Energie: %.1f / %s%s", computer.energy(), computer.maxEnergy(), string.rep(" ", 35)))
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
        print("Neustart in 5s")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    if (disk.spaceTotal() - disk.spaceUsed()) / 1024 < 500 then
        gpu.setForeground(0xFFFFFF)
        print(string.format("Festplatte: %.1fkB / %.1fkB", disk.spaceUsed() / 1024, disk.spaceTotal() / 1024))
        gpu.setForeground(0xFF0000)
        print("Nicht genügend Speicherplatz vorhanden (min. 500kB)")
        gpu.setForeground(0xFFFFFF)
        print(string.format("freier Speicherplatz: %.1fkB", (disk.spaceTotal() - disk.spaceUsed()) / 1024))
        return
    end
    Funktion.checkKomponenten()
    gpu.setForeground(0xFFFFFF)
    Funktion.status()
    print("Starte Download")
    id = event.timer(0.1, Funktion.status, math.huge)
    if wget("-f", Funktion.Pfad(true), "/github-liste.txt") and wget("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/OpenOS-Updater/json.lua", "/json.lua") then
        if Funktion.verarbeiten() then
            return
        end
    end
    event.cancel(id)
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

shell.setWorkingDirectory(alterPfad)
gpu.setForeground(0xFFFFFF)
