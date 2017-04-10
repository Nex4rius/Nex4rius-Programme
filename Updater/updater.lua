-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell         = require("shell")
local fs            = require("filesystem")
local component     = require("component")
local term          = require("term")
local gpu           = component.gpu
local args          = shell.parse(...)

local wget          = loadfile("/bin/wget.lua")
local kopieren      = loadfile("/bin/cp.lua")
local entfernen     = loadfile("/bin/rm.lua")

local alterPfad     = shell.getWorkingDirectory("/")

local Funktion      = {}
local hilfe         = false
local name, repo, tree, link

local adressen = {
    openos = {
        name = "MightyPirates",
        repo = "OpenComputers",
        tree = "master-MC1.7.10",
        link = "src/main/resources/assets/opencomputers/loot/openos/"
    }
    stargate = {
        name = "Nex4rius",
        repo = "Nex4rius-Programme",
        tree = "master"
        link = "Stargate-Programm/"
    }
}

shell.setWorkingDirectory("/")

if adressen.args[1] then
    name = adressen.args[1].name
    repo = adressen.args[1].repo
    tree = adressen.args[1].tree
    link = adressen.args[1].link
elseif type(args[1]) == "string" and type(args[2]) == "string" and type(args[3]) == "string" then
    name = args[1]
    repo = args[2]
    tree = args[3]
    if args[4] then
        link = args[4]
    else
        link = ""
    end
elseif args[1] == "hilfe" or args[1] == "help" or args[1] == "?" then
    hilfe = true
else
    print("<FEHLER> falsche Eingabe")
    hilfe = true
end

function Funktion.Pfad(api)
    if api then
        return "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/41acf2fa06990dcc4d740490cccd9d2bcec97edd?recursive=1"
    else
        return "https://raw.githubusercontent.com/MightyPirates/OpenComputers/master-MC1.7.10/src/main/resources/assets/opencomputers/loot/openos/"
    end
end

--https://api.github.com/repos/Nex4rius/Nex4rius-Programme/branches/master
--https://api.github.com/repos/Nex4rius/Nex4rius-Programme/git/trees/3e24c5cfe4824cdecfb0641cefff8ecacb4bc28e?recursive=1

function Funktion.Pfad(nummer)
    if nummer == 1 then
        return string.format("https://api.github.com/repos/%s/%s/branches/%s", name, repo, tree)
    elseif nummber == 2 then
        return string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, sha)
    elseif nummber == 3 then
        return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", name, repo, tree, link)
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
    if not wget("-f", Funktion.Pfad(1), "/github-liste.txt") then return end
    local f = io.open("/github-liste.txt", "r")
    sha = loadfile("/json.lua")():decode(f:read("*all")).commit.sha
    f:close()
    if not wget("-f", Funktion.Pfad(2), "/github-liste.txt") then return end
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
            if not wget("-f", Funktion.Pfad(3) .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
                komplett = false
                break
            end
        end
    end
    print("\nDownload Beendet\n")
    if dateien["truncated"] or not komplett then
        gpu.setForeground(0xFF0000)
        print("<FEHLER> Download unvollständig")
        entfernen("-rv", "/update")
        entfernen("-rv", "/github-liste.txt")
        shell.setWorkingDirectory(alterPfad)
        os.exit()
    else
        print("Ersetze alte Dateien\n")
        for i in fs.list("/update") do
            kopieren("-rv", "/update/" .. i, "/")
        end
        entfernen("-rv", "/update")
        entfernen("-rv", "/github-liste.txt")
        entfernen("-rv", "/updater.lua")
        entfernen("-rv", "/json.lua")
        gpu.setForeground(0x00FF00)
        print("Update vollständig")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    Funktion.checkKomponenten()
    gpu.setForeground(0xFFFFFF)
    print("Starte Download\n")
    if wget("-f", Funktion.Pfad(3) .. "Updater/json.lua", "/json.lua") then
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
