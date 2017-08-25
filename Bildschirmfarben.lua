local function test(screenid)
  os.sleep(0.1)
  local screenid = screenid or gpu.getScreen()
  local _, hoch = component.proxy(screenid).getAspectRatio()
  term.clear()
  if hoch <= 2 then
    gpu.setResolution(160, 16)
  else
    gpu.setResolution(160, 48)
  end
  os.sleep(0.1)
  local hex = {0x000000, 0x1F1F1F, 0x3F3F3F, 0x5F5F5F, 0x7F7F7F, 0x9F9F9F, 0xBFBFBF, 0xDFDFDF,
               0xFFFFFF, 0xDFFFDF, 0xBFFFBF, 0x9FFF9F, 0x7FFF7F, 0x5FFF5F, 0x3FFF3F, 0x1FFF1F,
               0x00FF00, 0x1FDF00, 0x3FBF00, 0x5F9F00, 0x7F7F00, 0x9F5F00, 0xBF3700, 0xDF1F00,
               0xFF0000, 0xDF001F, 0xBF003F, 0x9F005F, 0x7F007F, 0x5F009F, 0x3F00BF, 0x1F00DF,
               0x0000FF, 0x0000DF, 0x0000BF, 0x00009F, 0x00007F, 0x00005F, 0x00003F, 0x00001F,
               0x000000}
  for _, farbe in pairs(hex) do
    gpu.setBackground(farbe)
    term.clear()
  end
  gpu.setBackground(0x000000)
end

local gpu = require("component").getPrimary("gpu")

test()
