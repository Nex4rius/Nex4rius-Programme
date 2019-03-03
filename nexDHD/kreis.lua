local c = require("component")
local gpu = c.getPrimary("gpu")
local term = require("term")

os.sleep(2)

local o = {}
o[ 1] = "                                  "
o[ 2] = "          ▁▄▄██████▄▄▁          "
o[ 3] = "       ▄▟█▛▀▀▔    ▔▀▀▜█▙▄       "
o[ 4] = "     ▗██▀              ▀██▖     "
o[ 5] = "    ▟█▀                  ▀█▙    "
o[ 6] = "   ▟█▘                    ▝█▙   "
o[ 7] = "  ▐█▌                      ▐█▌  "
o[ 8] = "  ██                        ██  "
o[ 9] = "  ██                        ██  "
o[10] = "  ▐█▌                      ▐█▌  "
o[11] = "   ▜█▖                    ▗█▛   "
o[12] = "    ▜█▄                  ▄█▛    "
o[13] = "     ▝██▄              ▄██▘     "
o[14] = "       ▀▜█▙▄▄▁    ▁▄▄▟█▛▀       "
o[15] = "          ▔▀▀██████▀▀▔          "
o[16] = "                                  "

local a = 0x333333
local b = 0x555555
for screenid in c.list("screen") do
    gpu.bind(screenid, false)
    gpu.setResolution(32, 16)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    for y = 1, 16 do
        gpu.setBackground(a)
        gpu.set(1, y, o[y])
        a, b = b, a
    end
end

os.sleep(30)

os.execute("shutdown")
