-- pastebin run -f ySJv3YyT
local shell = require("shell")
local args = shell.parse(...)
os.execute("stargate/check.lua" .. args)
