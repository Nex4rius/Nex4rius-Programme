-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm
--
-- to save press "Ctrl + S"
-- to close press "Ctrl + W"
--

local IDC           = "" -- Iris Deactivation Code
local autoclosetime = 60 -- in seconds -- false for no autoclose
local RF            = false -- show energy in RF instead of EU
local Sprache       = "" -- deutsch / english
local side          = "unten" -- bottom, top, back, front, right or left
local autoUpdate    = true -- automatically updates the programm

----------don't change anything below---------------------------------

local installieren  = false
local control       = "On"

----------------------------------------------------------------------

if type(IDC) ~= "string" then
  IDC = ""
end
if type(autoclosetime) ~= "number" then
  autoclosetime = false
end
if type(RF) ~= "boolean" then
  RF = false
end
if type(Sprache) ~= "string" then
  Sprache = ""
end
if type(side) ~= "string" then
  side = "unten"
end
if type(installieren) ~= "boolean" then
  installieren = false
end
if type(control) ~= "string" then
  control = "On"
end
if type(autoUpdate) ~= "boolean" then
  autoUpdate = true
end

return IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun, autoUpdate
