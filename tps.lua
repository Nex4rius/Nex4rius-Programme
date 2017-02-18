-- original from ATastyPeanut https://github.com/ATastyPeanut/OpenComputers-Minecraft-Lua
-- pastebin run -f XXXXXXXX
-- modified by Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function tps()
  local timeConstant = 2
  local function time()
    local f = io.open("/tmp/timeFile","w")
    f:write("test")
    f:close()
    return(require("filesystem").lastModified("/tmp/timeFile"))
  end
  local realTimeOld = time()
  os.sleep(timeConstant)
  return 20000 * timeConstant / (time() - realTimeOld)
end

return tps
