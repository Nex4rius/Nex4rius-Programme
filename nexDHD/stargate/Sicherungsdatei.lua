-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD
--
-- zum speichern drücke "Strg + S"
-- zum schließen drücke "Strg + W"
--

return {
  autoclosetime = 60, -- in Sekunden -- false für keine automatische Schließung
  IDC           = "", -- Iris Deaktivierungscode
  RF            = false, -- zeige Energie in RF anstatt in EU
  Sprache       = "", -- deutsch / english / russian / czech / polish
  side          = "unten", -- unten, oben, hinten, vorne, rechts oder links
  autoUpdate    = true, -- aktiviere automatische Aktualisierungen
  StargateName  = "", -- der Name dieses Stargates
  Port          = 645, -- Standard 645
  Reichweite    = 50, -- Stärke des WLan-Signals
  Theme         = "normal", -- normal, dunkel, schwarz_weiss
  kein_senden   = false, -- true -> keine Adressen senden
  cloud         = true, -- Adressen in die Cloud hoch- und runterladen

----------verändere nichts ab hier---------------------------------

  debug         = false, -- zum debuggen
  control       = "On",
  installieren  = false,
}
