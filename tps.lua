-- original from ATastyPeanut https://github.com/ATastyPeanut/OpenComputers-Minecraft-Lua
-- pastebin run -f ZbxDmMeC
-- modified by Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function tps()
  local function time()
    local f = io.open("/tmp/TPS","w")
    f:write("test")
    f:close()
    return(require("filesystem").lastModified("/tmp/timeFile"))
  end
  local realTimeOld = time()
  os.sleep(1)
  return 20000 / (time() - realTimeOld)
end

return tps
