local c = require("component")
local gpu = c.getPrimary("gpu")
local term = require("term")
local a = {}
local kleine_anzeigen = c.list("screen")

os.sleep(2)

a.s = {}

a.s[ 1] = "                                "
a.s[ 2] = "         ▁▄▄████████▄▄▁         "
a.s[ 3] = "       ▄▟█▛▀▔▔    ▔▔▀▜█▙▄       "
a.s[ 4] = "     ▗██▀              ▀██▖     "
a.s[ 5] = "    ▟█▀                  ▀█▙    "
a.s[ 6] = "   ▟█▘                    ▝█▙   "
a.s[ 7] = "  ▐█▌                      ▐█▌  "
a.s[ 8] = "  ██                        ██  "
a.s[ 9] = "  ██                        ██  "
a.s[10] = "  ▐█▌                      ▐█▌  "
a.s[11] = "   ▜█▖                    ▗█▛   "
a.s[12] = "    ▜█▄                  ▄█▛    "
a.s[13] = "     ▝██▄              ▄██▘     "
a.s[14] = "       ▀▜█▙▄▁▁    ▁▁▄▟█▛▀       "
a.s[15] = "         ▔▀▀████████▀▀▔         "
a.s[16] = "                                "

a.stargate    = 0x3C3C3C
a.chevron_an  = 0xFF6D00
a.chevron_aus = 0x996D40
a.wurmloch    = 0x0000FF
a.irisfarbe   = 0xA5A5A5
a.aussen      = 0x000000

a.aktiv = {}
a.chevron = 0

a[1] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(25, 3, "▄")
    gpu.set(25, 4, "█▙")
    gpu.setBackground(a.innen)
    gpu.set(24, 4, "▀")
    if not aktiv then
        a.chevron = 0
    end
end

a[2] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(29, 7, "█▌")
    gpu.setBackground(a.innen)
    gpu.set(28, 7, "▐")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargate)
    gpu.set(29, 8, "▀▀")
end

a[3] = function()
    gpu.setBackground(a.aussen)
    gpu.set(27, 12, "█▛")
    gpu.setBackground(a.innen)
    gpu.set(26, 12, "▄")
end

a[4] = function()
    gpu.setBackground(a.aussen)
    gpu.set(5, 12, "▜█")
    gpu.setBackground(a.innen)
    gpu.set(7, 12, "▄")
end

a[5] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(3, 7, "▐█")
    gpu.setBackground(a.innen)
    gpu.set(5, 7, "▌")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargate)
    gpu.set(3, 8, "▀▀")
end

a[6] = function()
    gpu.setBackground(a.aussen)
    gpu.set(8, 3, "▄")
    gpu.set(7, 4, "▟█")
    gpu.setBackground(a.innen)
    gpu.set(9, 4, "▀")
end

a[7] = function(aktiv)
    gpu.set(16, 2, "██")
    if aktiv then
        if a.aussen == a.innen then
            a.innen = a.wurmloch
        end
        for chevron in pairs(a.aktiv) do
            if chevron ~= 7 then
                if a.aktiv[chevron] then
                    a.zeig_chevron(chevron, true)
                end
            end
        end
    end
end

a[8] = function()
    gpu.setBackground(a.aussen)
    gpu.set(21, 15, "▀▀")
    gpu.setBackground(a.innen)
    gpu.set(21, 14, "▄▟")
end

a[9] = function()
    gpu.setBackground(a.aussen)
    gpu.set(11, 15, "▀▀")
    gpu.setBackground(a.innen)
    gpu.set(11, 14, "▙▄")
end

function a.init()
    a.innen = a.aussen
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid, false)
        gpu.setResolution(32, 16)
        gpu.setBackground(a.aussen)
        gpu.setForeground(a.stargate)
        for y = 1, 16 do
            gpu.set(1, y, a.s[y])
        end
        for i = 1, 9 do
            a.zeig_chevron(i, false)
        end
    end
end

function a.iris(geschlossen)
    if geschlossen then
        a.innen = a.irisfarbe
    elseif a.chevron == 0 then
        a.init()
        return
    else
        a.innen = a.aussen
    end
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid, false)
        for chevron in pairs(a.aktiv) do
            a.zeig_chevron(chevron, a.aktiv[chevron])
        end
    end
end

function a.zeig_chevron(chevron, aktiv)
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    a[chevron](aktiv)
    a.aktiv[chevron] = aktiv
    a.chevron = chevron
end

a.init()

-------------------------------------------------------

os.sleep(5)

local anwahl = {}
anwahl[1] = 1
anwahl[2] = 2
anwahl[3] = 3
anwahl[4] = 4
anwahl[5] = 5
anwahl[6] = 6
anwahl[7] = 8
anwahl[8] = 9
anwahl[9] = 7

for _, i in pairs(anwahl) do
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid, false)
        a.zeig_chevron(i, true)
    end
    os.sleep(1)
end

os.sleep(10)
a.iris(true)

os.sleep(10)
a.iris(false)

os.sleep(10)
a.init()

os.sleep(30)

os.execute("shutdown")
