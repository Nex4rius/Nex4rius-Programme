local d = io.open(..., "r")
require("component").eeprom.set(d:read("*a"))
d:close()
