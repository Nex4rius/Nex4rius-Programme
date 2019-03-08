local c = require("component")
local gpu = c.getPrimary("gpu")
local term = require("term")
local kleine_anzeigen = c.list("screen")
local a = {}

os.sleep(2)

a.aktiv = {}

for i = 1, 9 do
    a.aktiv[i] = false
end

a.c = {}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"            XXXXXXXXXX          "},
    {"            XX      XX          "},
    {"            XX     XX           "},
    {"           XXX     XX           "},
    {"           XXXXXXXXX            "},
    {"           XXXXXXXXX            "},
    {"          XXX     XXX           "},
    {"         XXXX     XXXX          "},
    {"         XXX       XXXX         "},
    {"         XXX        XXX         "},
    {"          XXX       XXX         "},
    {"         XXXX      XXXXX        "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"              XXXXXX   X        "},
    {"            XXXXXX    XXXX      "},
    {"          XX X      XXX         "},
    {"           XXX    XXX           "},
    {"            XXXXXXX             "},
    {"           XXX XXX              "},
    {"           XXX XXX              "},
    {"           XXXXXXX              "},
    {"          XXX X XXXX            "},
    {"         XXX       XXXX         "},
    {"        XXX          X          "},
    {"        XXX                     "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"               XXXX             "},
    {"            XXXXX               "},
    {"          XXXXX                 "},
    {"       XXXXX XX                 "},
    {"            XXXX                "},
    {"              XXXX              "},
    {"               XXXX             "},
    {"                 XXXX           "},
    {"                  XXXXXX        "},
    {"                    XX  XX      "},
    {"                    XXXX        "},
    {"                    XX          "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                    XX          "},
    {"                   XXXX         "},
    {"                   XXX          "},
    {"                   XX           "},
    {"            X      XX           "},
    {"            XXX   XXX           "},
    {"           XXXXXXXXXX           "},
    {"                  XXX           "},
    {"              XXX  XX           "},
    {"            XXXX   XX           "},
    {"        XXXX       XXX          "},
    {"          XX       XXXX         "},
    {"           X       X            "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                   XXXX         "},
    {"           XXXXXXXXXXX          "},
    {"          XXXXXXXXX             "},
    {"         XXXX                   "},
    {"        XXXXX                   "},
    {"        XX XX                   "},
    {"       XX  XX                   "},
    {"        XX XX   XXXXXXXX        "},
    {"         XXXX XXXXXXXXXX        "},
    {"         XXXXXXXX               "},
    {"          XXXXX                 "},
    {"           XX                   "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                      XXXX      "},
    {"                      XXX       "},
    {"                     XXX        "},
    {"                    XXX         "},
    {"                    XX          "},
    {"             XXXXXXXX           "},
    {"           XXXX  XXX            "},
    {"         XXXXXXXX               "},
    {"        XXX                     "},
    {"        XX                      "},
    {"        XX                      "},
    {"       XXX                      "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"     XXXX                       "},
    {"      X XXXXX                   "},
    {"      XX  XXX                   "},
    {"      XXXXX                     "},
    {"      XXX                       "},
    {"                   XXX          "},
    {"                   XX XXX       "},
    {"                   XX  XXX      "},
    {"                    XXXX        "},
    {"                    XX          "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                 XXXXXXXX       "},
    {"                 XXXXXXXX       "},
    {"                 XX    XXX      "},
    {"                XXX   XXXX      "},
    {"                XXX  XXX        "},
    {"       XXXX     XX    X         "},
    {"       XXX     XXX              "},
    {"       XXX  XXXXX               "},
    {"       XXXXXXXX                 "},
    {"       XXXXX                    "},
    {"       XXX                      "},
    {"      XXXX                      "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                  X             "},
    {"                XXX             "},
    {"               XX XX            "},
    {"              XXXXXXX           "},
    {"                  XXXX          "},
    {"                    XXX         "},
    {"                     XXX        "},
    {"         X           XXX        "},
    {"        XX          XXX         "},
    {"       X  X        XXXX         "},
    {"      XXXXXX XXXXXXXXX          "},
    {"             XXXXXXX            "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"            X                   "},
    {"           XX                   "},
    {"           XX                   "},
    {"           XXX                  "},
    {"           X X XX               "},
    {"           X XX XX              "},
    {"          XX XX XXX             "},
    {"          XXXXXX                "},
    {"              XXX               "},
    {"               XXX              "},
    {"                XXXXX           "},
    {"                 XXX            "},
    {"                                "},
    {"                                "},
}


a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                 XXXX           "},
    {"           X     XXXXXXX        "},
    {"         XXX          XX        "},
    {"        XXXX          XX        "},
    {"       XX XX          XX        "},
    {"       XX XX    XX    XXX       "},
    {"       XX XXXXXXXXX   XXX       "},
    {"       X XXXXXXXXXXXXXXXX       "},
    {"       XXX    XXX XXXXX         "},
    {"       X     XXXXX              "},
    {"               XXXX             "},
    {"                 XX             "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"            XX                  "},
    {"            XXX                 "},
    {"            XX                  "},
    {"           XXX                  "},
    {"           XXX                  "},
    {"           XXX                  "},
    {"           XXXXXXX              "},
    {"               XXXXXXXX         "},
    {"                 XXXXXX         "},
    {"              XXXXX  XX         "},
    {"           XXXXXX               "},
    {"            XX                  "},
    {"            X                   "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"         XXXXX                  "},
    {"         XXX                    "},
    {"         XXX      XX            "},
    {"         XXX     XX XX          "},
    {"        XXX      XXX            "},
    {"        XXX                     "},
    {"        XXX             X       "},
    {"        XXX     XXXXXXXXXX      "},
    {"        XXXXXXXXXXXXXXXXXX      "},
    {"        XXXXXXX                 "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"            XXX                 "},
    {"            XXXXX               "},
    {"           XXXXXXXX             "},
    {"          XXX   XXXXX           "},
    {"          XXX     XXXX          "},
    {"         XXX        XXXX        "},
    {"        XXXX         XXXX       "},
    {"        XXXXXXXXXXXXXXXXXXX     "},
    {"       XXXXXXXXXXXXXXXX XXX     "},
    {"      XXX                       "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"               XXXXXXXXX        "},
    {"        XXXXXXXXX    X XX       "},
    {"     XXXX            X XX       "},
    {"     XX              XXX        "},
    {"      XXXX           XX         "},
    {"        XXXXXXXXXXXXXX          "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"        XXXXX     X             "},
    {"         XXXXXXXXXX             "},
    {"         XXX   XXXXX            "},
    {"          XX      XX            "},
    {"          XXX                   "},
    {"           XX                   "},
    {"           XXX                  "},
    {"            XXX                 "},
    {"            XXX   XXX           "},
    {"             XXXXXXXX           "},
    {"             XXXXXXXXX          "},
    {"              XX                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                  XXX           "},
    {"                  XX            "},
    {"                  XX            "},
    {"                  XX            "},
    {"                  XXX   X       "},
    {"             XX    XXXXXX       "},
    {"            XXXX     XXX        "},
    {"              XXX    XXX        "},
    {"               XXX XXXX         "},
    {"                XXXXXX          "},
    {"        XXXXXXXXXXXX            "},
    {"        XX                      "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                     XXX        "},
    {"       XXXXXX      XXXXX        "},
    {"      XXXXXXXXXXXXXX            "},
    {"     XXX        XX              "},
    {"       XXX       XX      XX     "},
    {"      XXXXXXXXXXXXX      X      "},
    {"    XXX         XXXXX           "},
    {"     X                          "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                    XXX         "},
    {"                    XXXX        "},
    {"                    XX          "},
    {"                   XXX          "},
    {"                   XX           "},
    {"                  XXX           "},
    {"                  XX            "},
    {"                 XXX            "},
    {"       XXXXXXXXXXXX             "},
    {"        XX     XXXX             "},
    {"         XX XXXX                "},
    {"          XXX                   "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                        XX      "},
    {"      XXXX            XXXX      "},
    {"     XX XXXXX     XXXXXXX       "},
    {"      XXXXXXXXXXXXXXX XXX       "},
    {"        X             XX        "},
    {"                      XX        "},
    {"                     XXX        "},
    {"                    XXX         "},
    {"                    XXX         "},
    {"                    XXX         "},
    {"                    XXX         "},
    {"                    XX          "},
    {"                                "},
    {"                                "},
}


a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"              XXX    XX XX      "},
    {"       XXXXXXXXXXXXXXXXXXX      "},
    {"     XXXXXX    XX     X         "},
    {"    XXXXXXXXXXXXX               "},
    {"              XX                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"       XX                       "},
    {"       XXXX                     "},
    {"        XXXXXX                  "},
    {"        XXX XXXXX               "},
    {"         XX    XXXX             "},
    {"          XX     XXXXX          "},
    {"          XXX       XXXXX       "},
    {"           XX       XXXX        "},
    {"           XXX    XXXX          "},
    {"            XXX XXXX            "},
    {"             XXXXX              "},
    {"             XXX                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"     X                          "},
    {"     XXXXXX           XXXXX     "},
    {"     XXXXXXXXXXXXXXXXXXXXXX     "},
    {"            XXXXXXX             "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"        XX                      "},
    {"       XXXX                     "},
    {"       XXXXXXX                  "},
    {"           XXXXX                "},
    {"             XXXXX              "},
    {"               XXXX             "},
    {"                 XXXXX          "},
    {"         XX       XXXX          "},
    {"        XXXX       X X          "},
    {"        XXXXXXXX   X X          "},
    {"            XXXXXXXXXXX         "},
    {"                  XXXXX         "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"        XX                      "},
    {"        XXXXXX                  "},
    {"        XXX XXXX                "},
    {"              XXXXXXXXXX        "},
    {"                XXXXXXXX        "},
    {"               XX     XX        "},
    {"               XX      XX       "},
    {"               XX   XXXXX       "},
    {"              XXXXXXXXXX        "},
    {"              XXX               "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                        XX      "},
    {"           XXXXXXXXXXXXXXX      "},
    {"    XXXXXXXXXXXXXXXXX    X      "},
    {"     XX        XXXXX            "},
    {"                  XXXXXXXXX     "},
    {"                         XX     "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"               XX               "},
    {"               XXX              "},
    {"         X                      "},
    {"         XXXX                   "},
    {"          XX                    "},
    {"          XX       X            "},
    {"          XXX      XXX          "},
    {"          XXX      XX           "},
    {"          XXX     XXX           "},
    {"         XXXXX    XX            "},
    {"          XXXXXXXXXX            "},
    {"           XXXXXXX              "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                       XXXX     "},
    {"                XXXXXX XXXXX    "},
    {"               XXXXXXXXXX       "},
    {"      XXX    XXXX  XXX          "},
    {"      XXXXXXXXXXX               "},
    {"         XXXXX                  "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"              XX                "},
    {"              XXXXXXXX          "},
    {"               X   XX           "},
    {"               XX XX            "},
    {"               X  XX            "},
    {"              XX XX             "},
    {"              XXXXX             "},
    {"            XX   XX             "},
    {"           XX    XX             "},
    {"         XXXXXX  XX             "},
    {"             XXXXXXX            "},
    {"                  XX            "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"               XXX              "},
    {"          XXXXXXXX              "},
    {"        XXXXX   XX              "},
    {"          XXX  XX               "},
    {"            XXXXX               "},
    {"              XXX               "},
    {"               XXX              "},
    {"               XXXXX            "},
    {"               XX  XXXX         "},
    {"              XX    XXXXX       "},
    {"              XXXXXXXX          "},
    {"              XXXX              "},
    {"                                "},
    {"                                "},
}


a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                    XXX         "},
    {"        XXX        XXXXX        "},
    {"     XXXXXXXXX   XXXX XXX       "},
    {"     X     XXXXXXXX    XXXX     "},
    {"              XXX        X      "},
    {"          XXXXXX                "},
    {"       XXX  XX                  "},
    {"         XXX                    "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                     XXXX       "},
    {"                     XXX        "},
    {"            XXXXXXXXXXXX        "},
    {"       XXXXXXXXXXXXXXXXX        "},
    {"      XXX             XX        "},
    {"      XXX             XX        "},
    {"       XXXXXXXXXXXXXXXXXX       "},
    {"       XXXXXX         XXX       "},
    {"       XX                       "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"      XXX                       "},
    {"      XXX                       "},
    {"      XXX                       "},
    {"        XXXX  XX                "},
    {"           XXX X                "},
    {"            X   XX XXXX         "},
    {"                  XXXXX         "},
    {"                      X         "},
    {"                     XXXXX      "},
    {"                       XXX      "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"   XXXXXXXXXXXX         X       "},
    {"  XXXXXXXXXXXXXXX      XX       "},
    {"   X           XXXXXXXXXX       "},
    {"                  XXX           "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"         XX                     "},
    {"         XX                     "},
    {"                                "},
    {"                XX              "},
    {"               XXX              "},
    {"              XX                "},
    {"             XX                 "},
    {"            XX                  "},
    {"           XXX                  "},
    {"           XX                   "},
    {"           XX                   "},
    {"           XXX                  "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"               XXX              "},
    {"               XX               "},
    {"                                "},
    {"               XX               "},
    {"               XX               "},
    {"                                "},
    {"                X               "},
    {"             XXXX               "},
    {"                XX              "},
    {"                 XX             "},
    {"                  XXX           "},
    {"                   XX           "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"                                "},
    {"        XX                      "},
    {"      XXXX                      "},
    {"        XXX                     "},
    {"         XXX                    "},
    {"          XXXX                  "},
    {"            XXXX                "},
    {"             XXXX               "},
    {"               XXXXX            "},
    {"                 XXXXXX         "},
    {"                    XXXXXXXXX   "},
    {"                       XXXXXX   "},
    {"                          XX    "},
    {"                                "},
    {"                                "},
    {"                                "},
}

a.c["Buchstabe_hier"] = {
    {"                                "},
    {"              XXX               "},
    {"            XXXXXXX             "},
    {"            XX   XX             "},
    {"            XX   XX             "},
    {"             XXXXX              "},
    {"               X                "},
    {"              XXX               "},
    {"             XXXXX              "},
    {"            XXXXXXX             "},
    {"           XXX   XXX            "},
    {"          XXX     XXX           "},
    {"         XXX       XXX          "},
    {"        XXX         XXX         "},
    {"       XXXX         XXXX        "},
    {"                                "},
    {"                                "},
}

a.s = {}

a.s.a = {
    {1,  1, "                                "},
    {1,  2, "         ▁▄▄████████▄▄▁         "},
    {1,  3, "       ▄▟█"},{23,  3, "█▙▄       "},
    {1,  4, "     ▗██"},  {25,  4,   "██▖     "},
    {1,  5, "    ▟█"},    {27,  5,     "█▙    "},
    {1,  6, "   ▟█"},     {28,  6,      "█▙   "},
    {1,  7, "  ▐█"},      {29,  7,       "█▌  "},
    {1,  8, "  ██"},      {29,  8,       "██  "},
    {1,  9, "  ██"},      {29,  9,       "██  "},
    {1, 10, "  ▐█"},      {29, 10,       "█▌  "},
    {1, 11, "   ▜█"},     {28, 11,      "█▛   "},
    {1, 12, "    ▜█"},    {27, 12,     "█▛    "},
    {1, 13, "     ▝██"},  {25, 13,   "██▘     "},
    {1, 14, "       ▀▜█"},{23, 14, "█▛▀       "},
    {1, 15, "         ▔▀▀████████▀▀▔         "},
    {1, 16, "                                "},
}

a.s.i = {
    {11,  3, "▛▀▔▔    ▔▔▀▜"},
    { 9,  4, "▀              ▀"},
    { 7,  5, "▀                  ▀"},
    { 6,  6, "▘                    ▝"},
    { 5,  7, "▌                      ▐"},
    { 5,  8, "                        "},
    { 5,  9, "                        "},
    { 5, 10, "▌                      ▐"},
    { 6, 11, "▖                    ▗"},
    { 7, 12, "▄                  ▄"},
    { 9, 13, "▄              ▄"},
    {11, 14, "▙▄▁▁    ▁▁▄▟"},
}

a.stargatefarbe = 0x3C3C3C
a.chevron_an    = 0xFF6D00
a.chevron_aus   = 0x996D40
a.wurmloch      = 0x0000FF
a.irisfarbe     = 0xA5A5A5
a.aussen        = 0x000000

a[1] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(25, 3, "▄")
    gpu.set(25, 4, "█▙")
    gpu.setBackground(a.innen)
    gpu.set(24, 4, "▀")
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
    gpu.setBackground(a.stargatefarbe)
    gpu.set(29, 8, "▀▀")
end

a[3] = function()
    gpu.setBackground(a.aussen)
    gpu.set(27, 12, "█▛")
    gpu.setBackground(a.innen)
    gpu.set(26, 12, "▄")
    gpu.set(27, 11, "▗")
end

a[4] = function()
    gpu.setBackground(a.aussen)
    gpu.set(5, 12, "▜█")
    gpu.setBackground(a.innen)
    gpu.set(7, 12, "▄")
    gpu.set(6, 11, "▖")
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
    gpu.setBackground(a.stargatefarbe)
    gpu.set(3, 8, "▀▀")
end

a[6] = function()
    gpu.setBackground(a.aussen)
    gpu.set(8, 3, "▄")
    gpu.set(7, 4, "▟█")
    gpu.setBackground(a.innen)
    gpu.set(9, 4, "▀")
end

a[7] = function()
    gpu.set(16, 2, "██")
end

a[8] = function(aktiv)
    gpu.setBackground(a.innen)
    gpu.set(21, 14, "▄▟")
    gpu.setBackground(a.aussen)
    gpu.set(21, 15, "▀▀▔")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(23, 14, "▄")
end

a[9] = function(aktiv)
    gpu.setBackground(a.innen)
    gpu.set(11, 14, "▙▄")
    gpu.setBackground(a.aussen)
    gpu.set(10, 15, "▔▀▀")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(10, 14, "▄")
end

function a.init()
    a.innen = a.aussen
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid)
        gpu.setResolution(32, 16)
    end
    a.stargate()
end

function a.stargate(ausgeschaltet)
    if ausgeschaltet then
        for i = 1, 9 do
            a.aktiv[i] = false
            a.innen = a.aussen
        end
    end
    if a.aktiv[7] and a.aussen == a.innen then
        a.innen = a.wurmloch
    end
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid, false)
        gpu.setForeground(a.stargatefarbe)
        gpu.setBackground(a.aussen)
        for _, v in pairs(a.s.a) do
            gpu.set(v[1], v[2], v[3])
        end
        gpu.setBackground(a.innen)
        for _, v in pairs(a.s.i) do
            gpu.set(v[1], v[2], v[3])
        end
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
end

function a.iris(geschlossen)
    if geschlossen then
        a.innen = a.irisfarbe
    elseif not a.aktiv[1] then
        a.stargate(true)
        return
    else
        a.innen = a.aussen
    end
    a.stargate()
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
--anwahl[7] = 8
--anwahl[8] = 9
anwahl[9] = 7

for _, i in pairs(anwahl) do
    a.aktiv[i] = true
    os.sleep(1)
    a.stargate()
end

os.sleep(10)
a.iris(true)

os.sleep(10)
a.iris(false)

os.sleep(10)
a.stargate(true)

os.sleep(30)

os.execute("shutdown")
