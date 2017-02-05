-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

return {
--Beispiel                  = {schriftAN, hinterAN, schriftAUS, hinterAUS},
--example                   = {textON,    backON,    textOFF,   backOFF},
  lava                      = {0x000000,  0xCF4E0C,  0xFFFFFF,  0x9C3A09},
  water                     = {0xFFFFFF,  0x2A3BF1,  0xFFFFFF,  0x212BC0},
  ic2distilledwater         = {0xFFFFFF,  0x2A3BF1,  0xFFFFFF,  0x212BC0},
  chlorine                  = {0xFFFFFF,  0x2E8C8C,  0xFFFFFF,  0x1E5A5A},
  oil                       = {0xFFFFFF,  0x010101,  0xFFFFFF,  0x333333},
  liquidlightoil            = {0xFFFFFF,  0x010101,  0xFFFFFF,  0x333333},
  liquidmediumoil           = {0xFFFFFF,  0x010101,  0xFFFFFF,  0x333333},
  liquidheavyoil            = {0xFFFFFF,  0x010101,  0xFFFFFF,  0x333333},
  liquidnaphtha             = {0xFFFFFF,  0xFCED00,  0xFFFFFF,  0xCABD00},
  liquidlpg                 = {0x000000,  0xFCF8A9,  0x000000,  0xCAC888},
  liquidheavyfuel           = {0x000000,  0xFCEBB1,  0x000000,  0xCABC8E},
  liquidlightfuel           = {0x000000,  0xFCED00,  0x000000,  0xCABD00},
  liquidcrackedlightfuel    = {0x000000,  0xFCED00,  0x000000,  0xCABD00},
  liquidcrackedheavyfuel    = {0x000000,  0xFCECB4,  0x000000,  0xCABF90},
  xpjuice                   = {0x000000,  0x50FC01,  0x000000,  0x419C04},
  radon                     = {0x000000,  0xEE54FA,  0x000000,  0xC446F2},
  nitrogendioxide           = {0x000000,  0x83F9FC,  0x000000,  0x5DB0B3},
  hydrogen                  = {0x000000,  0xFC6464,  0xFFFFFF,  0xCD5252},
  oxygen                    = {0x000000,  0x009DCD,  0xFFFFFF,  0x00799E},
  nitrogen                  = {0x000000,  0xB80000,  0xFFFFFF,  0x850000},
  moltenredstone            = {0x000000,  0x9C0B0B,  0xFFFFFF,  0x690707},
  mercury                   = {0x000000,  0xBDBDBD,  0xFFFFFF,  0x8A8A8A},
  fuel                      = {0x000000,  0x888300,  0xFFFFFF,  0x666300},
  diesel                    = {0x000000,  0x888300,  0xFFFFFF,  0x666300},
  nitrofuel                 = {0x000000,  0xCFE400,  0x000000,  0xA1B300},
  ic2biogas                 = {0x000000,  0x9B8D45,  0xFFFFFF,  0x695F2F},
  ic2uumatter               = {0xFFFFFF,  0x730A6C,  0xFFFFFF,  0x41063E},
  biomass                   = {0x000000,  0x64852A,  0xFFFFFF,  0x3D521A},
  seedoil                   = {0x000000,  0xFCFC96,  0x000000,  0xCACA79},
  tritium                   = {0x000000,  0xFC0000,  0x000000,  0xCA0000},
  deuterium                 = {0x000000,  0xF9FC00,  0x000000,  0xC3CA00},
  helium                    = {0xFFFFFF,  0x9D2500,  0xFFFFFF,  0x6C1900},
  helium3                   = {0x000000,  0xF9FC8E,  0x000000,  0xC7CA71},
  methane                   = {0xFFFFFF,  0x747200,  0xFFFFFF,  0x404000},
  liquidhydricsulfur        = {0x000000,  0xFC5100,  0x000000,  0xCA4300},
  fluorine                  = {0x000000,  0x5296D1,  0xFFFFFF,  0x3E729F},
  creosote                  = {0xFFFFFF,  0x6D6800,  0xFFFFFF,  0xA19C00},
  glue                      = {0x000000,  0xFBC986,  0x000000,  0xC89F6A},
  forhoney                  = {0x000000,  0xFCAB1F,  0x000000,  0xCA8918},
  lubricant                 = {0x000000,  0xFCEAAD,  0x000000,  0xCABC8C},
  gasnaturalgas             = {0x000000,  0xB2B2B2,  0xFFFFFF,  0x808080},
  milk                      = {0x000000,  0xFCFCFC,  0x000000,  0xCDCDCD},
  plasmahelium              = {0x000000,  0xE8FC00,  0x000000,  0xB6CA00},
  plasmanitrogen            = {0x000000,  0x0094C6,  0xFFFFFF,  0x006D94},
  plasmairon                = {0x000000,  0xB6C6C6,  0x000000,  0x899494},
  plasmasulfur              = {0x000000,  0xB9C600,  0xFFFFFF,  0x8B9400},
  plasmaoxygen              = {0xFFFFFF,  0x0063C6,  0xFFFFFF,  0x004A94},
  plasmanickel              = {0x000000,  0xB6C6F7,  0x000000,  0x929EC5},
  moltenneutronium          = {0x000000,  0xC7C7C7,  0x000000,  0x949494},
  etchacid                  = {0xFFFFFF,  0x732F07,  0xFFFFFF,  0x401904},
  plastic                   = {0x000000,  0x838383,  0xFFFFFF,  0x4F4F4F},
  lpgPC                     = {0x000000,  0xE9D41C,  0x000000,  0xB6A616},
  air                       = {0xFFFFFF,  0x010101,  0xFFFFFF,  0x333333},
  toluene                   = {0x000000,  0x6A2200,  0xFFFFFF,  0x381300},
  liquidepichlorhyrin       = {0x000000,  0x6D2300,  0xFFFFFF,  0x3B1400},
  moltenepoxid              = {0x000000,  0x9F6F10,  0xFFFFFF,  0x6C4B0B},
  moltenplastic             = {0x000000,  0x9D9D9Dv  0xFFFFFF,  0x6C6C6C},
  unbekannt                 = {0xFFFFFF,  0x444444,  0xFFFFFF,  0x333333},
}
