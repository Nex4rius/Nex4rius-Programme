-- pastebin run -f MHq2tN5B [-f] name repo tree [link [sha]]
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell         = require("shell")
local fs            = require("filesystem")
local component     = require("component")

local args, options = shell.parse(...)

local wget          = loadfile("/bin/wget.lua")
local verschieben   = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen     = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

local alterPfad     = shell.getWorkingDirectory()

local Funktion      = {}

local link, name, repo, tree, hilfe, gpu, sha

if component.isAvailable("gpu") then
    gpu = component.gpu
else
    gpu = {}
    gpu.setForeground = function() end
end

shell.setWorkingDirectory("/")

if args1 == "?" then
    hilfe = true
elseif type(args[1]) == "string" and type(args[2]) == "string" and type(args[3]) == "string" then
    name = args[1]
    repo = args[2]
    tree = args[3]
    if type(args[4]) == "string" then
        link = args[4]
    end
    if type(args[5]) == "string" then
        sha = args[5]
    end
else
    gpu.setForeground(0xFF0000)
    print("<FEHLER> falsche Eingabe")
    hilfe = true
end

function Funktion.status()
    gpu.set(x, 2, string.format("   RAM: %.1fkB / %.1fkB%s", (computer.totalMemory() - computer.freeMemory()) / 1024, computer.totalMemory() / 1024, string.rep(" ", 35)))
    gpu.set(x, 4, string.format("   Energie: %.1f / %s%s", computer.energy(), computer.maxEnergy(), string.rep(" ", 35)))
    gpu.set(x, 6, string.format("   Speicher: %.1fkB / %.1fkB%s", disk.spaceUsed() / 1024, disk.spaceTotal() / 1024, string.rep(" ", 35)))
    gpu.set(x, 1, string.rep(" ", 35))
    gpu.set(x, 3, string.rep(" ", 35))
    gpu.set(x, 5, string.rep(" ", 35))
    gpu.set(x, 7, string.rep(" ", 35))
    gpu.set(x, 8, string.rep(" ", 35))
end

function Funktion.Hilfe()
    print([==[Benutzung: github [-f] name repo tree [link [sha]]]==])
    print([==[sha nur benötigt bei sehr großen Repositories]==])
    print([==[Bei "-f" werden die Dateien immer sofort überschrieben, nur erforderlich bei geringer Festplattenkapazität. >>>WARNUNG<<< Ein Downloadfehler beim updaten von OpenOS mit "-f" wird dafür sorgen das der Computer nicht mehr bootet.]==])
    print()
    print([==[Beispiele:]==])
    print([==[github Nex4rius Nex4rius-Programme master Stargate-Programm]==])
    print([==[github MightyPirates OpenComputers master-MC1.7.10 src/main/resources/assets/opencomputers/loot/openos/ 285f9c8fa60abf54dd6b199c895c9e07943c6d1d]==])
    print()
    print([==[Hilfetext:]==])
    print([==[github ?]==])
    print()
    print([==[Einbindung in Programme:]==])
    print([==[1) loadfile("/bin/github.lua")(name:string, repo:string, tree:string[, link:string[, sha:string]])]==])
    print([==[2) loadfile("/bin/pastebin.lua")("-f", "run", "MHq2tN5B", name:string, repo:string, tree:string[, link:string[, sha:string]])]==])
end

function Funktion.checkKomponenten()
    require("term").clear()
    local weiter = true
    print("Prüfe Komponenten\n")
    local function check(eingabe)
        Funktion.status()
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
        {"internet", "- Internet   ok"           , "- Internet   fehlt"           , true},
        {"gpu"     , "- GPU        ok - optional", "- GPU        fehlt - optional", },
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
    print("\nDownloade Verzeichnisliste\n")
    Funktion.status()
    if sha then
        if not wget("-f", string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, sha), "/temp/github-liste.txt") then
            gpu.setForeground(0xFF0000)
            print("<FEHLER> GitHub Download")
            return 
        end
    else
        if not wget("-f", string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, tree), "/temp/github-liste.txt") then
            gpu.setForeground(0xFF0000)
            print("<FEHLER> GitHub Download")
            return 
        end
    end
    Funktion.status()
    local f = io.open("/temp/github-liste.txt", "r")
    print("\nKonvertiere: JSON -> Lua table\n")
    local dateien = loadfile("/temp/json.lua")():decode(f:read("*all"))
    f:close()
    entfernen("/temp/github-liste.txt")
    print()
    if link then
        for i in pairs(dateien.tree) do
            Funktion.status()
            if dateien.tree[i].path == link then
                sha = dateien.tree[i].sha
                break
            end
        end
        if not wget("-f", string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, sha), "/temp/github-liste-kurz.txt") then
            gpu.setForeground(0xFF0000)
            print("<FEHLER> GitHub Download")
            return 
        end
        f = io.open("/temp/github-liste-kurz.txt", "r")
        print("\nKonvertiere: JSON -> Lua table\n")
        dateien = loadfile("/temp/json.lua")():decode(f:read("*all"))
        f:close()
        entfernen("/temp/github-liste-kurz.txt")
        print()
        link = link .. "/"
    else
        link = ""
    end
    fs.makeDirectory("/update")
    local komplett = true
    print("Erstelle Verzeichnisse\n")
    for i in pairs(dateien.tree) do
        Funktion.status()
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
            print("/update/" .. dateien.tree[i].path)
            os.sleep(0.1)
        end
    end
    print("\nStarte Download\n")
    local pfad = "/update"
    if options.o then
        pfad = ""
    end
    for i in pairs(dateien.tree) do
        Funktion.status()
        if dateien.tree[i].type == "blob" and dateien.tree[i].path ~= "README.md" then
            if not wget("-f", string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", name, repo, tree, link) .. dateien.tree[i].path, pfad .. "/" .. dateien.tree[i].path) then
                komplett = false
                break
            end
        end
    end
    if dateien["truncated"] or not komplett then
        gpu.setForeground(0xFF0000)
        print("\n<FEHLER> Download unvollständig\n")
        if dateien["truncated"] then
            print("<FEHLER> GitHub Dateiliste unvollständig\n")
        end
        gpu.setForeground(0xFFFFFF)
        entfernen("/update")
        entfernen("/temp")
        shell.setWorkingDirectory(alterPfad)
        os.exit()
    else
        gpu.setForeground(0x00FF00)
        print("\nDownload Beendet\n")
        gpu.setForeground(0xFFFFFF)
        print("Ersetze alte Dateien")
        local function kopieren(...)
            for i in fs.list(...) do
                if fs.isDirectory(i) then
                    kopieren(i)
                end
                verschieben("/update/" .. i, "/" .. i)
                Funktion.status()
            end
        end
        entfernen("/update")
        entfernen("/temp")
        gpu.setForeground(0x00FF00)
        print("\nUpdate vollständig")
        os.sleep(2)
        return true
    end
end

local function main()
    Funktion.checkKomponenten()
    gpu.setForeground(0xFFFFFF)
    if hilfe then
        Funktion.Hilfe()
    else
        fs.makeDirectory("/temp")
        local a = "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/"
        if wget("-fQ", a .. "github.lua", "/temp/github.lua") then
            verschieben("/temp/github.lua", "/bin/github.lua")
        end
        print("Downloade Konverter\n")
        if wget("-f", a .. "json.lua", "/temp/json.lua") then
            if Funktion.verarbeiten() then
                return true
            end
        end
        gpu.setForeground(0xFF0000)
        print("<FEHLER> Download")
    end
end

Funktion.status()
local ergebnis, grund = pcall(main)

if not ergebnis then
    gpu.setForeground(0xFF0000)
    print("<FEHLER> main")
    print(grund)
    if grund == "not enough memory" and option.f then
        if not link then link = "" end
        if not sha then sha = "" end
        os.execute(string.format("pastebin run -f MHq2tN5B -o %s %s %s %s", name, repo, tree, link, sha))
    end
end

shell.setWorkingDirectory(alterPfad)
gpu.setForeground(0xFFFFFF)
return ergebnis
