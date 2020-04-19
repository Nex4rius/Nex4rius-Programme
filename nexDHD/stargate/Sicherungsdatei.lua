-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD
--
-- zum speichern drücke "Strg + S"
-- zum schließen drücke "Strg + W"
--

return {
  autoclosetime = 60, -- in seconds -- false for no autoclose
  IDC           = "", -- Iris Deactivation Code
  RF            = false, -- show energy in RF instead of EU
  Sprache       = "", -- deutsch / english / russian / czech
  side          = "unten", -- bottom, top, back, front, right or left
  autoUpdate    = true, -- enable automated updates
  StargateName  = "", -- the name of this stargate
  Port          = 645, -- default 645
  Reichweite    = 30, -- strength of the wireless signal
  Theme         = "normal", -- normal, dunkel, schwarz_weiss
  kein_senden   = false, -- true -> keine Adressen senden
  cloud         = true, -- Adressen in die Cloud hoch- und runterladen

----------don't change anything below---------------------------------

  debug         = false, -- for debugging
  control       = "On",
  installieren  = false,
}
