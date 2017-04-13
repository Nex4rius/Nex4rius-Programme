-- pastebin run -f MHq2tN5B name repo tree [link]
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell         = require("shell")
local fs            = require("filesystem")
local component     = require("component")

local args1         = shell.parse(...)[1]
local args2         = shell.parse(...)[2]
local args3         = shell.parse(...)[3]
local args4         = shell.parse(...)[4]

local wget          = loadfile("/bin/wget.lua")
local kopieren      = loadfile("/bin/cp.lua")
local verschieben   = loadfile("/bin/mv.lua")
local entfernen     = loadfile("/bin/rm.lua")

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
elseif type(args1) == "string" and type(args2) == "string" and type(args3) == "string" then
    name = args1
    repo = args2
    tree = args3
    if type(args4) == "string" then
        link = args4
    end
else
    gpu.setForeground(0xFF0000)
    print("<FEHLER> falsche Eingabe")
    hilfe = true
end

function Funktion.Hilfe()
    print([=[Benutzung: github name repo tree [link]]=])
    print()
    print([=[Beispiele:]=])
    print([=[github Nex4rius Nex4rius-Programme master Stargate-Programm]=])
    print()
    print([=[Hilfetext:]=])
    print([=[github ?]=])
    print()
    print([=[Einbindung in Programme:]=])
    print([=[loadfile("/bin/github.lua")(name: string, repo: string, tree: string[, link: string])]=])
end

function Funktion.checkKomponenten()
    require("term").clear()
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
    if not wget("-f", string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, tree), "/temp/github-liste.txt") then
        gpu.setForeground(0xFF0000)
        print("<FEHLER> GitHub Download")
        return 
    end
    local f = io.open("/temp/github-liste.txt", "r")
    print("\nKonvertiere: JSON -> Lua table\n")
    local dateien = loadfile("/temp/json.lua")():decode(f:read("*all"))
    f:close()
    entfernen("-rv", "/temp/github-liste.txt")
    if link then
        for i in pairs(dateien.tree) do
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
        entfernen("-rv", "/temp/github-liste-kurz.txt")
        link = link .. "/"
    else
        link = ""
    end
    fs.makeDirectory("/update")
    local komplett = true
    print("Erstelle Verzeichnisse\n")
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
            print("/update/" .. dateien.tree[i].path)
            os.sleep(0.1)
        end
    end
    print("\nStarte Download\n")
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "blob" and dateien.tree[i].path ~= "README.md" then
            if not wget("-f", string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", name, repo, tree, link) .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
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
        entfernen("-rv", "/update")
        entfernen("-rv", "/temp")
        shell.setWorkingDirectory(alterPfad)
        os.exit()
    else
        gpu.setForeground(0x00FF00)
        print("\nDownload Beendet\n")
        gpu.setForeground(0xFFFFFF)
        print("Ersetze alte Dateien\n")
        for i in fs.list("/update") do
            if not verschieben("-fv", "/update/" .. i, "/") then
                entfernen("-r", "/" .. i)
                kopieren("-rv", "/update/" .. i, "/")
            end
        end
        print()
        entfernen("-rv", "/update")
        entfernen("-rv", "/temp")
        gpu.setForeground(0x00FF00)
        print("\nUpdate vollständig")
        print("\nNeustart in 3s")
        os.sleep(3)
        require("computer").shutdown(true)
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
            verschieben("-f", "/temp/github.lua", "/bin/github.lua")
        end
        print("Downloade Konverter\n")
        if wget("-f", a .. "json.lua", "/temp/json.lua") then
            if Funktion.verarbeiten() then return end
        end
        gpu.setForeground(0xFF0000)
        print("<FEHLER> Download")
    end
end

local ergebnis, grund = pcall(main)

if not ergebnis then
    gpu.setForeground(0xFF0000)
    print("<FEHLER> main")
    print(grund)
end

shell.setWorkingDirectory(alterPfad)
gpu.setForeground(0xFFFFFF)
