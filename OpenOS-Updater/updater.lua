-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

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

local verschieben   = function(von, nach) gpu.setForeground(0x00FF00) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) gpu.setForeground(0xFFFFFF) end
local entfernen     = function(datei) gpu.setForeground(0xFF0000) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) gpu.setForeground(0xFFFFFF) end

local original_wget = loadfile("/bin/wget.lua")

local f = {}
--local MINECRAFT_VERSION = "master-MC1.7.10"
local MINECRAFT_VERSION = "master-MC1.12"

local ersetzen, id, sha

x = x - 35

local function wget(...)
    for i = 1, 21 do
        if original_wget(...) then
            return true
        end
        if i > 20 then
            return false
        end
        print("\nDownloadfehler ... Neustart in " .. i .. "s")
        os.sleep(i)
    end
end

function f.json_decode(d)
    return loadfile("/json.lua")():decode(d:read("*all"))
end

function f.Pfad(api)
    if api then
        if not sha then
            f.check_sha()
        end
        return "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/" .. sha .. "?recursive=1"
    else
        return "https://raw.githubusercontent.com/MightyPirates/OpenComputers/" .. MINECRAFT_VERSION .. "/src/main/resources/assets/opencomputers/loot/openos/"
    end
end

function f.check_sha()
    sha = MINECRAFT_VERSION
    local a = {"src", "main", "resources", "assets", "opencomputers", "loot", "openos"}
    for k, v in pairs(a) do
        local dateiname = string.format("/github-liste-%s.txt", v)
        wget("-f", "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/" .. sha, dateiname)
        local d = io.open(dateiname, "r")
        local dateien = f.json_decode(d)
        d:close()
        entfernen(dateiname)
        for i in pairs(dateien.tree) do
            if dateien.tree[i].type == "tree" and dateien.tree[i].path == v then
                sha = dateien.tree[i].sha
            end
        end
    end
end

function f.checkKomponenten()
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

function f.status()
    gpu.set(x, 2, string.format("   RAM: %.1fkB / %.1fkB%s", (computer.totalMemory() - computer.freeMemory()) / 1024, computer.totalMemory() / 1024, string.rep(" ", 35)))
    gpu.set(x, 4, string.format("   Energie: %.1f / %s%s", computer.energy(), computer.maxEnergy(), string.rep(" ", 35)))
    gpu.set(x, 6, string.format("   Speicher: %.1fkB / %.1fkB%s", disk.spaceUsed() / 1024, disk.spaceTotal() / 1024, string.rep(" ", 35)))
    gpu.set(x, 1, string.rep(" ", 35))
    gpu.set(x, 3, string.rep(" ", 35))
    gpu.set(x, 5, string.rep(" ", 35))
    gpu.set(x, 7, string.rep(" ", 35))
    gpu.set(x, 8, string.rep(" ", 35))
end

function f.verarbeiten()
    local function kopieren(...)
        for i in fs.list(...) do
            f.status()
            if fs.isDirectory(i) then
                kopieren(i)
            end
            verschieben("/update/" .. i, "/" .. i)
        end
    end
    local d = io.open("/github-liste.txt", "r")
    local dateien = f.json_decode(d)
    d:close()
    entfernen("/github-liste.txt")
    fs.makeDirectory("/update")
    local komplett = true
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
        end
    end
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "blob" then
            f.status()
            if not wget("-f", f.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
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
        gpu.setForeground(0xFFFFFF)
        event.cancel(id)
        return true
    else
        print("Ersetze alte Dateien")
        kopieren("/update")
        f.status()
        entfernen("/update")
        f.status()
        entfernen("/updater.lua")
        f.status()
        entfernen("/json.lua")
        f.status()
        gpu.setForeground(0x00FF00)
        print("Update vollständig")
        gpu.setForeground(0xFFFFFF)
        print("Neustart in 5s")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    if (disk.spaceTotal() - disk.spaceUsed()) / 1024 < 512 then
        gpu.setForeground(0xFFFFFF)
        print(string.format("Festplatte: %.1fkB / %.1fkB", disk.spaceUsed() / 1024, disk.spaceTotal() / 1024))
        gpu.setForeground(0xFF0000)
        print("Nicht genügend Speicherplatz vorhanden (min. 550kB)")
        gpu.setForeground(0xFFFFFF)
        print(string.format("freier Speicherplatz: %.1fkB", (disk.spaceTotal() - disk.spaceUsed()) / 1024))
        return
    end
    f.checkKomponenten()
    gpu.setForeground(0xFFFFFF)
    f.status()
    print("Starte Download")
    id = event.timer(0.1, f.status, math.huge)
    if wget("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/OpenOS-Updater/json.lua", "/json.lua") and wget("-f", f.Pfad(true), "/github-liste.txt") then
        if f.verarbeiten() then
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
