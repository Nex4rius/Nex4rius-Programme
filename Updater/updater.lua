-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell         = require("shell")
local fs            = require("filesystem")
local component     = require("component")
local term          = require("term")
local gpu           = component.gpu
local args1         = shell.parse(...)[1]
local args2         = shell.parse(...)[2]
local args3         = shell.parse(...)[3]
local args4         = shell.parse(...)[4]

local wget          = loadfile("/bin/wget.lua")
local kopieren      = loadfile("/bin/cp.lua")
local entfernen     = loadfile("/bin/rm.lua")

local alterPfad     = shell.getWorkingDirectory("/")

local Funktion      = {}
local hilfe         = false
local name, repo, tree, link

local adressen = {
    openos = {
        name = [[MightyPirates]],
        repo = [[OpenComputers]],
        tree = [[master-MC1.7.10]],
        link = [[src/main/resources/assets/opencomputers/loot/openos/]],
    },
    stargate = {
        name = [[Nex4rius]],
        repo = [[Nex4rius-Programme]],
        tree = [[master]],
        link = [[Stargate-Programm/]],
    },
}

shell.setWorkingDirectory("/")

if string.lower(tostring(adressen.args1)) and args1 then
    name = adressen.args1.name
    repo = adressen.args1.repo
    tree = adressen.args1.tree
    link = adressen.args1.link
elseif type(args1) == "string" and type(args2) == "string" and type(args3) == "string" then
    name = args1
    repo = args2
    tree = args3
    if args4 then
        link = args4
    else
        link = ""
    end
elseif args1 == "hilfe" or args1 == "help" or args1 == "?" then
    hilfe = true
else
    print("<FEHLER> falsche Eingabe")
    hilfe = true
end

--https://api.github.com/repos/Nex4rius/Nex4rius-Programme/branches/master
--https://api.github.com/repos/Nex4rius/Nex4rius-Programme/git/trees/3e24c5cfe4824cdecfb0641cefff8ecacb4bc28e?recursive=1

function Funktion.Pfad(nummer)
    if nummer == "1" then
        return string.format("https://api.github.com/repos/%s/%s/branches/%s", name, repo, tree)
    elseif nummber == "2" then
        return string.format("https://api.github.com/repos/%s/%s/git/trees/%s?recursive=1", name, repo, sha)
    elseif nummber == "3" then
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
    if not wget("-f", Funktion.Pfad("1"), "/github-liste.txt") then return end
    local f = io.open("/github-liste.txt", "r")
    sha = loadfile("/json.lua")():decode(f:read("*all")).commit.sha
    f:close()
    if not wget("-f", Funktion.Pfad("2"), "/github-liste.txt") then return end
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
            if not wget("-f", Funktion.Pfad("3") .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
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
    if wget("-f", Funktion.Pfad("3") .. "Updater/json.lua", "/json.lua") then
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
