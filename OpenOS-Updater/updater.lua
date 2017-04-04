-- pastebin run -f icKy25PF
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local fs            = require("filesystem")
local component     = require("component")
local term          = require("term")

local wget          = loadfile("/bin/wget.lua")
local kopieren      = loadfile("/bin/cp.lua")
local entfernen     = loadfile("/bin/rm.lua")

local Funktion      = {}
local Sprache       = {}
local gpu

function Funktion.Pfad(api)
    if api then
        return "https://api.github.com/repos/MightyPirates/OpenComputers/git/trees/41acf2fa06990dcc4d740490cccd9d2bcec97edd?recursive=1"
    else
        return "https://raw.githubusercontent.com/MightyPirates/OpenComputers/master-MC1.7.10/src/main/resources/assets/opencomputers/loot/openos/"
    end
end

--[[
function Funktion.checkSprache()
    local alleSprachen = {}
    local weiter = true
    for i in fs.list("/updater/sprache") do
        local Ende = string.len(i)
        i = string.sub(i, 1, Ende - 4)
    end
    while weiter do
        print("Sprache? / Language?")
        for i in pairs(alleSprachen) do
            io.write(alleSprachen[i] .. "   ")
        end
        io.write("\n\n")
        antwortFrageSprache = string.lower(tostring(io.read()))
        for i in pairs(alleSprachen) do
            if antwortFrageSprache == alleSprachen[i] then
                weiter = false
                break
            end
        end
    end
    SpracheAuswahl = antwortFrageSprache
    print("")
    if pcall(loadfile("/updater/sprache/" .. SpracheAuswahl .. ".lua")) then
        Sprache = loadfile("/updater/sprache/" .. SpracheAuswahl .. ".lua")()
    end
end
]]

function Funktion.checkKomponenten()
    term.clear()
    local weiter = true
    print(Sprache.pruefeKomponenten or "Prüfe Komponenten\n")
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
        {"internet", Sprache.InternetOK or "- Internet             ok", Sprache.InternetFehlt or "- Internet             fehlt", true},
        {"gpu",      Sprache.GpuOK      or "- GPU                  ok", Sprache.GpuFehlt      or "- GPU                  fehlt"},
    }
    for i in pairs(alleKomponenten) do
        check(alleKomponenten[i])
    end
    gpu.setForeground(0xFFFFFF)
    if not weiter then
        os.exit()
    end
end

function Funktion.verarbeiten()
    local a = io.open("/updater/ausgabe.lua", "w")
    local f = io.open("/updater/github-liste.txt", "r")
    zeichen = {
        ["["] = [===[{]===],
        [":"] = [===[=]===],
    }
    local function zeichenErsetzen(...)
        return string.gsub(..., "%a+", function (str) return zeichen [str] end)
    end
    a:write("return ")
    for zeile in f:lines() do
        a:write(zeichenErsetzen(zeile) .. "\n")
    end
    io.open("/updater/github-liste.txt", "r"):close()
    a:close()
    entfernen("/updater/github-list.txt")
    dateien = loadfile("/updater/ausgabe.lua")()
    fs.makeDirectory("/update")
    local komplett = true
    gpu.setForeground(0xFFFFFF)
    print(Sprache.starteDownload or "Starte Download")
    for i in pairs(dateien.tree) do
        if dateien.tree[i].type == "tree" then
            fs.makeDirectory("/update/" .. dateien.tree[i].path)
        elseif dateien.tree[i].type == "blob" then
            if not wget("-f", Funktion.Pfad() .. dateien.tree[i].path, "/update/" .. dateien.tree[i].path) then
                komplett = false
            end
        end
    end
    print(Sprache.DownloadBeendet or "Download Beendet")
    if dateien["truncated"] or not komplett then
        gpu.setForeground(0xFF0000)
        print((Sprache.fehler .. Sprache.unvollstaendig) or "<FEHLER> Download unvollständig")
        return false
    else
        print(Sprache.alteErsetzen or "Ersetze alte Dateien")
        for i in fs.list("/update") do
            kopieren("-rv", "/update/" .. i, "/" .. i)
        end
        entfernen("-rv", "/update")
        gpu.setForeground(0x00FF00)
        print(Sprache.UpdateVollstaendig or "Update vollständig")
        os.sleep(5)
        require("computer").shutdown(true)
    end
end

local function main()
    --Funktion.checkSprache()
    Funktion.checkKomponenten()
    if wget("-f", Funktion.Pfad(true), "/updater/github-liste.txt") then
        if Funktion.verarbeiten() then
            return
        end
    end
    gpu.setForeground(0xFF0000)
    print(string.format("%s %s", Sprache.fehler, Sprache.downloadfehlerGitHub) or "<FEHLER> GitHub Download")
end

if not pcall(main) then
    gpu.setForeground(0xFF0000)
    print(string.format("%s %s main", Sprache.fehler, Sprache.funktion) or "<FEHLER> Funktion main")
end

gpu.setForeground(0xFFFFFF)
