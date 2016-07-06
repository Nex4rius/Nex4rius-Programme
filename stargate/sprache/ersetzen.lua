-- pastebin run -f 1pbsaeCQ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local sprachen = require("shell").parse(...)[1]

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
