-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

os.sleep(2)

local io              = io
local os              = os
local table           = table
local string          = string
local print           = print
local pcall           = pcall
local require         = require
local loadfile        = loadfile

local component       = require("component")
local fs              = require("filesystem")
local serialization   = require("serialization")
local c               = require("computer")
local event           = require("event")
local term            = require("term")
local unicode         = require("unicode")

local farben          = loadfile("/tank/farben.lua")()
local ersetzen        = loadfile("/tank/ersetzen.lua")()
local original_wget   = loadfile("/bin/wget.lua")

local gpu             = component.getPrimary("gpu")
local m               = component.getPrimary("modem")

local version, tankneu, energie, Updatetimer

local port            = 918
local arg             = string.lower(tostring(... or nil))
local tank            = {}
local tank_a          = {}
local f               = {}
local o               = {}
local timer           = {}
local Sensorliste     = {}
local debugscreens    = {}
local laeuft          = true
local updateAktiv     = true
local debug           = false
local Sendeleistung   = math.huge
local Wartezeit       = 150
local Zeit            = 60
local letzteNachricht = c.uptime()
local letztesAnzeigen = letzteNachricht
local UpdatecheckZeit = -100
local erlaubeAnzeigen = true
local insert          = table.insert

local maxbreite = {}
for i = 1, 8 do
    maxbreite[i] = 80
end
maxbreite[9] = 88
maxbreite[10] = 98
maxbreite[11] = 108
maxbreite[12] = 118
maxbreite[13] = 128
maxbreite[14] = 138
maxbreite[15] = 147
maxbreite[16] = 157

local function wget(...)
    local a = {...}
    for i = 1, 21 do
        if original_wget(...) then
            return true
        end
        if i > 20 then
            return false
        end
        print("\n\n" .. a[2] .. "\n" .. a[3] .. "\nDownloadfehler ... Neustart in " .. i .. "s")
        os.sleep(i)
    end
end

if fs.exists("/tank/version.txt") then
    local d = io.open("/tank/version.txt", "r")
    version = d:read()
    d:close()
    d = io.open("/tank/client/tank/version.txt", "w")
    d:write(version)
    d:close()
else
    version = "<FEHLER>"
end

if arg == "n" or arg == "nein" or arg == "no" then
    arg = nil
else
    arg = true
end

m.setStrength(math.huge)

local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function f.tank(hier, id, nachricht)
    local dazu = true
    local ende = 0
    if hier then
        letzteNachricht = c.uptime()
        for i = 1, #tank do
            if type(tank[i]) == "table" then
                if tank[i].id == id then
                    tank[i].zeit = c.uptime()
                    tank[i].inhalt = serialization.unserialize(nachricht)
                    dazu = false
                end
            end
            ende = i
        end
        if dazu then
            ende = ende + 1
            tank[ende] = {}
            tank[ende].id = id
            tank[ende].zeit = c.uptime()
            tank[ende].inhalt = serialization.unserialize(nachricht)
        end
    else
        f.keineDaten()
    end
    for i = 1, #tank do
        if c.uptime() - tank[i].zeit > Wartezeit * 2 then
            tank[i] = nil
        end
    end
    f.verarbeiten(tank)
end

function f.verarbeiten(tank)
    tank_a = {}
    for i in pairs(tank) do
        if type(tank[i]) == "table" then
            if type(tank[i].inhalt) == "table" then
                local gruppe
                for j in pairs(tank[i].inhalt) do
                    if tank[i].inhalt[j].name == "Tankname" then
                        gruppe = tank[i].inhalt[j].label
                        if tank_a[gruppe] then
                            break
                        else
                            tank_a[gruppe] = {}
                            tank_a[gruppe][1] = {}
                            tank_a[gruppe][1].name = "Tankname"
                            tank_a[gruppe][1].label = gruppe
                            tank_a[gruppe][1].menge = "1"
                            tank_a[gruppe][1].maxmenge = "1"
                        end
                    end
                end
                for j in pairs(tank[i].inhalt) do
                    local name = tank[i].inhalt[j].name
                    local label = tank[i].inhalt[j].label
                    local einheit = tank[i].inhalt[j].einheit
                    local menge = tank[i].inhalt[j].menge
                    local maxmenge = tank[i].inhalt[j].maxmenge
                    local weiter = true
                    if name ~= "Tankname" then
                        for k in pairs(tank_a[gruppe]) do
                            if tank_a[gruppe][k].name == name then
                                tank_a[gruppe][k].menge = tank_a[gruppe][k].menge + menge
                                tank_a[gruppe][k].maxmenge = tank_a[gruppe][k].maxmenge + maxmenge
                                weiter = false
                            end
                        end
                        if weiter then
                            local k = #tank_a[gruppe] + 1
                            tank_a[gruppe][k] = {}
                            tank_a[gruppe][k].name = name
                            tank_a[gruppe][k].label = label
                            tank_a[gruppe][k].einheit = einheit
                            tank_a[gruppe][k].menge = menge
                            tank_a[gruppe][k].maxmenge = maxmenge
                        end
                    end
                end
            end
        end
    end
    tankneu = {}
    if tank_a["false"] then
        local v = tank_a["false"]
        for _, w in spairs(v, function(t,a,b) return tonumber(t[b].menge) < tonumber(t[a].menge) end) do
            if w.name ~= "Tankname" then
                tankneu[#tankneu + 1] = w
            end
        end
    end
    for gruppe, v in pairs(tank_a) do
        if gruppe ~= "false" then            
            for _, w in pairs(v) do
                if w.name == "Tankname" then
                    tankneu[#tankneu + 1] = w
                end
            end
            for _, w in spairs(v, function(t,a,b) return (tonumber(t[b].menge) < tonumber(t[a].menge)) or (tonumber(t[a].menge) == tonumber(t[b].menge) and string.lower(t[a].label) <= string.lower(t[b].label)) end) do
                if w.name ~= "Tankname" then
                    tankneu[#tankneu + 1] = w
                end
            end
        end
    end
end

function f.position(maxanzahl, klein)
    local pos = {}
    local x = 1
    local y = 1
    local max = maxanzahl
    if max > 64 then
        max = 64
    end
    for anzahl = 1, max do
        local links, rechts, breite = -15, -25, 40
        if (32 - max) >= anzahl and max < 32 then
            links = 40
            rechts = 40
            breite = 160
        elseif (64 - max) >= anzahl and max > 16 then
            links, rechts = 0, 0
            breite = 80
        end
        if anzahl == 17 or anzahl == 33 or anzahl == 49 then
            if max > 48 and anzahl > 48 then
                x = 41
                if klein and max > 5 then
                    y = 1 + (64 - max)
                else
                    y = 1 + 3 * (64 - max)
                end
                breite = 40
            elseif max > 32 and anzahl > 32 then
                x = 121
                if klein and max > 5 then
                    y = 1 + (48 - max)
                else
                    y = 1 + 3 * (48 - max)
                end
                breite = 40
            else
                x = 81
                if klein and max > 5 then
                    y = 1 + (32 - max)
                else
                    y = 1 + 3 * (32 - max)
                end
            end
            if y < 1 then
                y = 1
            end
        end
        if max <= 16 then
            if klein and max <= 5 then
                breite = 160
            else
                breite = maxbreite[max]
            end
            local a = 160 - breite
            links = links - (math.floor(a / 2))
            rechts = rechts - (math.ceil(a / 2))
        end
        pos[anzahl] = {}
        pos[anzahl].links = links
        pos[anzahl].rechts = rechts
        pos[anzahl].breite = breite
        pos[anzahl].x = x
        pos[anzahl].y = y
        if klein and max > 5 then
            y = y + 1
        else
            y = y + 3
        end
    end
    if max > 48 then -- fix 2 und 4 Spalte vertauschen
        local a = max - 48
        for i = max + a, 17 + a, -1 do
            pos[i] = pos[i - a]
        end
        local j = 17
        for i = max + 1, #pos do
            pos[j] = pos[i]
            pos[i] = nil
            j = j + 1
        end
    end
    if maxanzahl > 64 then
        local max = maxanzahl
        if max > 128 then
            max = 128
        end
        local j = 64
        for i = max, 65, -1 do
            pos[i] = {}
            pos[i].links =  pos[j].links
            pos[i].rechts = pos[j].rechts
            pos[i].breite = 20
            pos[j].breite = 20
            pos[i].x = pos[j].x + 20
            pos[i].y = pos[j].y
            j = j - 1
        end
        pos = f.spaltensortierung(pos, max)
    end
    if maxanzahl > 128 then
        local j = 128
        for i = maxanzahl, 129, -1 do
            pos[i] = {}
            pos[i].links =  pos[j].links
            pos[i].rechts = pos[j].rechts
            pos[i].breite = 10
            pos[j].breite = 10
            pos[i].x = pos[j].x + 10
            pos[i].y = pos[j].y
            j = j - 1
        end
        pos = f.spaltensortierung(pos, maxanzahl)
    end
    return pos
end

function f.spaltensortierung(pos, maxanzahl)
    local sort = {}
    for i = 1, maxanzahl do
        local spalte = tostring(pos[i].x)
        if not sort[spalte] then
            sort[spalte] = {}
        end
        sort[spalte][#sort[spalte] + 1] = pos[i]
    end
    local position = {}
    local a = 1
    for i = 1, 160, 10 do
        local spalte = tostring(i)
        if sort[spalte] then
            for j = 1, #sort[spalte] do
                position[a] = sort[spalte][j]
                a = a + 1
            end
        end
    end
    return position
end

function f.anzeigen()
    if erlaubeAnzeigen then
        local anzeige_reset_timer = event.timer(30, f.anzeige_reset, 1)
        erlaubeAnzeigen = false
        local tankanzeige = tankneu
        if not tankanzeige then
            f.keineDaten()
            erlaubeAnzeigen = true
            return
        end
        f.debug("Anzeigen werden aktualisiert")
        local maxanzahl = #tankanzeige
        if maxanzahl > 256 then
            f.debug(string.format("Maximale Anzahl überschritten! %s/256", maxanzahl))
            maxanzahl = 256
        end
        for screenid in component.list("screen") do
            gpu.bind(screenid, false)
            if f.checksize(screenid) then
                local klein = false
                local x_breit, hoch = component.proxy(screenid).getAspectRatio()
                if hoch <= 2 then
                    klein = true
                end
                local a, b = gpu.getResolution()
                local function gpu_setRes(x, y)
                    if a ~= x or b ~= y then
                        gpu.setResolution(x, y)
                    end
                end
                if maxanzahl <= 16 and maxanzahl ~= 0 then
                    if klein and maxanzahl > 5 then
                        gpu_setRes(maxbreite[maxanzahl], maxanzahl)
                    elseif klein then
                        gpu_setRes(160, maxanzahl * 3)
                    else
                        gpu_setRes(maxbreite[maxanzahl], maxanzahl * 3)
                    end
                else
                    if klein and maxanzahl > 5 then
                        gpu_setRes(160, 16)
                    else
                        gpu_setRes(160, 48)
                    end
                end
                os.sleep(0.1)
                local pos = f.position(maxanzahl, klein)
                local leer = true
                for i = 1, maxanzahl do
                    local name = string.gsub(tankanzeige[i].name, "%p", "")
                    local label = f.zeichenErsetzen(string.gsub(tankanzeige[i].label, "%p", ""))
                    local einheit = tankanzeige[i].einheit
                    local menge = tankanzeige[i].menge
                    local maxmenge = tankanzeige[i].maxmenge
                    local prozent = f.ErsetzePunktMitKomma(string.format("%.1f%%", menge / maxmenge * 100))
                    if label == "fluidhelium3" then --workaround
                        label = "Helium-3"
                    end
                    f.zeigeHier(
                        pos[i].x,
                        pos[i].y,
                        label,
                        name,
                        menge,
                        maxmenge,
                        string.format("%s%s", string.rep(" ", 8 - string.len(prozent)), prozent),
                        pos[i].links,
                        pos[i].rechts,
                        pos[i].breite,
                        string.sub(string.format(" %s", label), 1, 31),
                        klein,
                        maxanzahl,
                        einheit
                    )
                    if debug then
                        gpu.set(pos[i].x, pos[i].y, string.format("%s / %s X:%s Y:%s ", i, maxanzahl, pos[i].x, pos[i].y))
                    end
                    leer = false
                end
                f.Farben(0xFFFFFF, 0x000000)
            end
            if leer then
                f.keineDaten()
            end
        end
        for screenid in component.list("screen") do
            gpu.bind(screenid, false)
            local x, y = component.proxy(screenid).getAspectRatio()
            if x == 1 and y == 1 then
                break -- immer mit Debugscreen warten
            end
        end
        letztesAnzeigen = c.uptime()
        erlaubeAnzeigen = true
        event.cancel(anzeige_reset_timer)
    end
end

function f.anzeige_reset()
    f.debug("<FEHLER> Bildschirme werden zurückgesetzt")
    f.text("<FEHLER> Bildschirme werden zurückgesetzt")
    f.workaround()
    erlaubeAnzeigen = true
    f.anzeigen()
end

function f.zeichenErsetzen(...)
    return string.gsub(..., "%a+", function (str) return ersetzen[str] end)
end

function f.ErsetzePunktMitKomma(...)
    local Punkt = string.find(..., "%.")
    if type(Punkt) == "number" then
        return string.sub(..., 0, Punkt - 1) .. "," .. string.sub(..., Punkt + 1)
    end
    return ...
  end

function f.zu_SI(wert)
    wert = tonumber(wert)
    if     wert < 10000 then
        wert = string.format("%.f" , wert) .. " "
    elseif wert < 10000000 then
        wert = string.format("%.1f", wert / 1000) .. " k "
    elseif wert < 10000000000 then
        wert = string.format("%.2f", wert / 1000000) .. " M "
    elseif wert < 10000000000000 then
        wert = string.format("%.3f", wert / 1000000000) .. " G "
    elseif wert < 10000000000000000 then
        wert = string.format("%.3f", wert / 1000000000000) .. " T "
    elseif wert < 10000000000000000000 then
        wert = string.format("%.3f", wert / 1000000000000000) .. " P "
    elseif wert < 10000000000000000000000 then
        wert = string.format("%.3f", wert / 1000000000000000000) .. " E "
    else
        wert = string.format("%.3f", wert / 1000000000000000000000) .. " Z "
    end
    return f.ErsetzePunktMitKomma(wert)
end

function f.checkFarbe(name)
    local ergebnis = ""
    local hex
    for k, v in pairs(farben) do
        if (string.find(k, name) or string.find(name, k)) and string.len(k) > string.len(ergebnis) then
            hex = v
            ergebnis = k
        end
    end
    if hex then
        farben[name] = hex
        return ergebnis
    end
    return "unbekannt"
end

function f.entferne_Molten(text) -- nicht genung Platz entfernt das Molten davor
    if string.sub(text, 1, 8) == " Molten " then
        return " " .. string.sub(text, 9)
    end
    return text
end

function f.zeigeHier(x, y, label, name, menge, maxmenge, prozent, links, rechts, breite, nachricht, klein, maxanzahl, einheit)
    local ausgabe = {}
    if name == "Tankname" then
        if klein and maxanzahl > 5 then
            insert(ausgabe, "━" .. string.rep("━", math.floor((breite - unicode.len(label)) / 2) - 2) .. " ")
            insert(ausgabe, string.sub(label, 1, breite - 4))
            insert(ausgabe, " " .. string.rep("━", math.ceil((breite - unicode.len(label)) / 2) - 2) .. "━")
        else
            insert(ausgabe, " ┃ " .. string.rep(" ", math.floor((breite - unicode.len(label)) / 2) - 3))
            insert(ausgabe, string.sub(label, 1, breite - 6))
            insert(ausgabe, string.rep(" ", math.ceil((breite - unicode.len(label)) / 2) - 3) .. " ┃ ")
        end
    else
        local menge = menge
        local maxmenge = maxmenge
        if einheit == "EU" or einheit == "RF" then
            menge = f.zu_SI(menge)
            maxmenge = f.zu_SI(maxmenge)
        end
        menge = " " .. menge
        if breite == 10 then
            nachricht = f.entferne_Molten(nachricht)
            insert(ausgabe, string.sub(nachricht, 1, breite - 1))
            insert(ausgabe, string.rep(" ", breite - 1 - unicode.len(nachricht)))
        elseif breite == 20 then
            nachricht = f.entferne_Molten(nachricht)
            insert(ausgabe, string.sub(nachricht, 1, breite - 3 - string.len(menge)))
            insert(ausgabe, string.rep(" ", breite - 1 - unicode.len(nachricht) - string.len(menge) - string.len(einheit)))
            insert(ausgabe, menge)
            insert(ausgabe, einheit)
        elseif breite == 40 then
            insert(ausgabe, string.sub(nachricht, 1, breite - 3 - string.len(menge) - string.len(prozent)))
            insert(ausgabe, string.rep(" ", breite - 1 - unicode.len(nachricht) - string.len(menge) - string.len(prozent) - string.len(einheit)))
            insert(ausgabe, menge)
            insert(ausgabe, einheit)
            insert(ausgabe, prozent)
        else
            insert(ausgabe, string.sub(nachricht, 1, 25))
            insert(ausgabe, string.rep(" ", links + 40 - unicode.len(nachricht) - string.len(menge) - string.len(einheit)))
            insert(ausgabe, menge)
            insert(ausgabe, einheit)
            insert(ausgabe, " / ")
            insert(ausgabe, maxmenge)
            insert(ausgabe, einheit)
            insert(ausgabe, string.rep(" ", rechts + 28 - string.len(maxmenge) - string.len(einheit)))
            insert(ausgabe, prozent)
        end
        insert(ausgabe, " ")
    end
    nachricht = split(table.concat(ausgabe))
    if farben[name] == nil then
        name = f.checkFarbe(name)
    end
    local oben  = " ┏" .. string.rep("━", breite - 4) .. "┓ "
    local unten = " ┗" .. string.rep("━", breite - 4) .. "┛ "
    local grenze = math.ceil(breite * menge / maxmenge)
    f.Farben(farben[name][1], farben[name][2])
    if klein and maxanzahl > 5 then
        if name == "Tankname" then
            gpu.set(x, y, table.concat(nachricht))
        else
            gpu.set(x, y, table.concat(nachricht, nil, 1, grenze))
        end
    else
        if name == "Tankname" then
            gpu.set(x, y, oben)
            gpu.set(x, y + 1, table.concat(nachricht))
            gpu.set(x, y + 2, unten)
        else
            gpu.fill(x, y, grenze, 1, " ")
            gpu.set(x, y + 1, table.concat(nachricht, nil, 1, grenze))
            gpu.fill(x, y + 2, grenze, 1, " ")
        end
    end
    x = x + grenze
    f.Farben(farben[name][3], farben[name][4])
    if klein and maxanzahl > 5 then
        if name ~= "Tankname" then
            gpu.set(x, y, table.concat(nachricht, nil, grenze + 1))
        end
    else
        if name ~= "Tankname" then
            gpu.fill(x, y, breite - grenze, 1, " ")
            gpu.set(x, y + 1, table.concat(nachricht, nil, grenze + 1))
            gpu.fill(x, y + 2, breite - grenze, 1, " ")
        end
    end
end

function f.Farben(vorne, hinten)
    if type(vorne) == "number" then
        gpu.setForeground(vorne)
    else
        gpu.setForeground(0xFFFFFF)
    end
    if type(hinten) == "number" then
        gpu.setBackground(hinten)
    else
        gpu.setBackground(0x333333)
    end
end

function split(...)
    local output = {}
    for i = 1, string.len(...) do
        output[i] = string.sub(..., i, i)
    end
    return output
end

function f.checksize(screenid)
    local x, y = component.proxy(screenid).getAspectRatio()
    if x == 1 and y == 1 then
        debugscreens[screenid] = true
    elseif (x == 8 and (y == 5 or y == 2)) or (x == 4 and y == 1) then
        debugscreens[screenid] = false
        return true
    else
        debugscreens[screenid] = false
        f.Farben(0xFFFFFF, 0x000000)
        term.clear()
        gpu.setResolution(28, 4)
        gpu.set(1, 1, "error: wrong screen size")
        gpu.set(1, 2, string.format("current size: %sx%s", x, y))
        gpu.set(1, 3, "allowed sizes: 4x1, 8x2, 8x5")
        gpu.set(1, 4, "debug size: 1x1")
    end
end

function f.debug(text)
    local davor_screenid = gpu.getScreen()
    for screenid in component.list("screen") do
        if debugscreens[screenid] then
            gpu.bind(screenid, false)
            local x, y = component.proxy(screenid).getAspectRatio()
            if x == 1 and y == 1 then
                f.Farben(0xFFFFFF, 0x000000)
                if type(text) == "table" then
                    text = serialization.serialize(text)
                end
                term.write(string.format("\nDebugscreen:\nZeit: %s --- %s\n%s\n\n", os.time(), c.uptime(), text))
            else
                debugscreens[screenid] = false
            end
        end
    end
    if davor_screenid then
        gpu.bind(davor_screenid, false)
    end
end

function f.text(a, b)
    if type(a) == "string" then
        for screenid in component.list("screen") do
            gpu.bind(screenid, false)
            if f.checksize(screenid) then
                if b then
                    gpu.setResolution(gpu.maxResolution())
                else
                    f.Farben(0xFFFFFF, 0x000000)
                    gpu.set(1, 1, a)
                    gpu.setResolution(string.len(a), 1)
                end
                f.Farben(0xFFFFFF, 0x000000)
                gpu.set(1, 1, a)
            end
        end
    end
end

function f.keineDaten()
    Sensorliste = {}
    tankneu = nil
    for k, v in pairs(timer) do
        event.cancel(v)
    end
    f.text("Keine Daten vorhanden")
    timer.tank = event.timer(Wartezeit + 15, f.tank, 1)
    timer.senden = event.timer(Zeit, f.senden, math.huge)
    m.broadcast(port, "tank")
end

function f.tankliste()
    for k, v in pairs(Sensorliste) do
        f.tank(v[1], v[3], v[8])
    end
end

function f.bildschirm_aktualisieren()
    if c.uptime() - letztesAnzeigen > Zeit then
        f.anzeigen()
    end
end

function f.datei(id, datei)
    if fs.exists("/tank/client" .. datei) then
        local d = io.open("/tank/client" .. datei, "r")
        local inhalt = d:read("*a")
        local i = 0
        local art = "w"
        local max_packet = 4000
        while true do
            local sende_inhalt = string.sub(inhalt, max_packet * i + 1, max_packet * (i + 1))
            if sende_inhalt == "" then
                break
            end
            m.send(id, port, "datei", datei, sende_inhalt, art)
            i = i + 1
            art = "a"
        end
        d:close()
    end
end

function o.speichern(signal)
    if not signal[7] then
        f.datei(signal[3], signal[8])
    end
end

function o.tankliste(signal)
    local dazu = true
    if version ~= signal[7] then
        --f.checkUpdate()
        --f.update(signal) -- buggy
    end
    for k, v in pairs(Sensorliste) do
        if Sensorliste[k][3] == signal[3] then
            dazu = false
            Sensorliste[k] = signal
            break
        end
    end
    if dazu then
        insert(Sensorliste, signal)
    end
    for k, v in pairs(timer) do
        event.cancel(v)
    end
    timer.tank = event.timer(Wartezeit + 15, f.tank, 1)
    timer.jetzt = event.timer(2, f.tankliste, 1)
    timer.senden = event.timer(Zeit, f.senden, math.huge)
    timer.tankliste = event.timer(Zeit + 15, f.tankliste, math.huge)
    timer.beenden = event.timer(Wartezeit + 30, f.beenden, 1)
    timer.anzeigen = event.timer(5, f.anzeigen, 1)
end

function f.update(signal)
    local dateiliste = {"/tank/auslesen.lua", "/tank/version.txt", "/autorun.lua"}
    for k, v in pairs(dateiliste) do
        f.datei(signal[3], v)
    end
    m.send(signal[3], port, "aktualisieren", serialization.serialize(dateiliste))
end

function f.event(...)
    local signal = {...}
    f.debug(string.format("Event: %s", serialization.serialize(signal)))
    if o[signal[6]] then
        if Sendeleistung < signal[5] + 50 or Sendeleistung == math.huge then
            Sendeleistung = signal[5] + 50
        end
        o[signal[6]](signal)
    end
end

function f.senden()
    if m.isWireless() then
        m.setStrength(Sendeleistung)
    end
    Sensorliste = {}
    m.broadcast(port, "tank")
end

function f.checkUpdate(text)
    if text then
        for screenid in component.list("screen") do
            gpu.bind(screenid, false)
            local x, y = component.proxy(screenid).getAspectRatio()
            if x == 1 and y == 1 then
                break
            end
        end
        term.setCursor(gpu.getResolution())
        term.clear()
        print("\nPrüfe Version\n")
        print("Derzeitige Version:      " .. (version or "<FEHLER>"))
        io.write("Verfügbare Version:      ")
    end
    if component.isAvailable("internet") then
        if c.uptime() - UpdatecheckZeit > 60 then
            serverVersion = f.checkServerVersion("master")
            serverBetaVersion = f.checkServerVersion("Tank")
            UpdatecheckZeit = c.uptime()
        end
    end
    if text then
        print(serverVersion)
        if serverBetaVersion ~= "<FEHLER>" and serverBetaVersion ~= serverVersion then
            io.write("Verfügbare Beta Version: ")
            print(serverBetaVersion .. "\n\n\nUpdate auf Beta? [j/N]\n")
            local antwort = io.read()
            if antwort == "j" then
                f.text("Update...")
                if wget("-fQ", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/installieren.lua", "/installieren.lua") then
                    f.beenden()
                    require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
                    print(pcall(loadfile("/installieren.lua"), "Tank"))
                    os.execute("reboot")
                end
            else
                updateAktiv = false
            end
        end
        print()
        os.sleep(2)
    end
    if updateAktiv and serverVersion and arg and component.isAvailable("internet") and serverVersion ~= version and serverBetaVersion ~= version then
        f.text("Update...")
        if wget("-fQ", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Tank/installieren.lua", "/installieren.lua") then
            f.beenden()
            require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
            print(pcall(loadfile("/installieren.lua"), "Tank"))
            os.execute("reboot")
        end
    end
end

function f.workaround() -- Bildschirme resetten damit sie wieder Farben akzeptieren
    for screenid in component.list("screen") do
        gpu.bind(screenid)
    end
end

function f.component_removed(...)
    local e = {...}
    f.debug("Komponente entfernt")
    f.debug(e)
end

function f.main()
    f.workaround()
    f.Farben(0xFFFFFF, 0x000000)
    f.checkUpdate(true)
    Updatetimer = event.timer(43200, f.checkUpdate, math.huge)
    m.open(port + 1)
    m.setWakeMessage("tankliste", true)
    f.text("Warte auf Daten")
    event.listen("modem_message", f.event)
    event.listen("component_removed", f.component_removed)
    timer.senden = event.timer(Zeit, f.senden, math.huge)
    timer.tank = event.timer(Zeit + 15, f.tank, 1)
    timer.beenden = event.timer(Wartezeit + 30, f.beenden, 1)
    f.senden()
    event.listen("interrupted", f.beenden)
    while laeuft do
        f.bildschirm_aktualisieren()
        os.sleep(5)
    end
    return true
end

function f.beenden()
    laeuft = false
    event.ignore("modem_message", f.event)
    event.ignore("component_removed", f.component_removed)
    event.ignore("interrupted", f.beenden)
    for k, v in pairs(timer) do
        if type(v) == "number" then
            event.cancel(v)
        end
    end
    if type(Updatetimer) == "number" then
        event.cancel(Updatetimer)
    end
    event.push("beenden")
    for screenid in component.list("screen") do
        local x, y = component.proxy(screenid).getAspectRatio()
        if x == 1 and y == 1 then
            gpu.bind(screenid, false)
            os.sleep(0.1)
            f.Farben(0xFFFFFF, 0x000000)
            term.clear()
            print("Tankanzeige wird ausgeschaltet")
            break
        end
    end
    f = nil
    o = nil
    gpu.setResolution(gpu.maxResolution())
    event.push("interrupted")
end

function f.checkServerVersion(branch)
    branch = branch or "master"
    local serverVersion = "<FEHLER>"
    if wget("-fQ", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. branch .. "/Tank/version.txt", "/serverVersion.txt") then
        local d = io.open ("/serverVersion.txt", "r")
        serverVersion = d:read()
        d:close()
        fs.remove("/serverVersion.txt")
    end
    return serverVersion
end

loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Tankanzeige")

local beenden = f.beenden

local ergebnis, grund = pcall(f.main)

if not ergebnis then
    f.debug("<FEHLER> f.main")
    f.debug(grund)
    os.sleep(2)
    beenden()
end
