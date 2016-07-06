-- pastebin run -f 1pbsaeCQ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local args = require("shell").parse(...)

if type(args[1]) == "string" then
  Sprache = string.lower(args[1])
else
  return false
end

local sprachen = loadfile("/stargate/sprache/" .. Sprache .. ".lua")()

return {
  ["On"]        = sprachen.irisKontrolleNameAn,
  ["Off"]       = sprachen.irisKontrolleNameAus,
  ["Open"]      = sprachen.irisNameOffen,
  ["Opening"]   = sprachen.irisNameOeffnend,
  ["Closed"]    = sprachen.irisNameGeschlossen,
  ["Closing"]   = sprachen.irisNameSchliessend,
  ["Offline"]   = sprachen.irisNameOffline,
  ["Override"]  = sprachen.Eingriff,
  ["Manual"]    = sprachen.manueller,
  ["Control"]   = sprachen.IrisSteuerungName,
}
