-- original from ATastyPeanut https://github.com/ATastyPeanut/OpenComputers-Minecraft-Lua
-- pastebin run -f XXXXXXXX
-- modified by Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local function tps()
  local function time()
    local f = io.open("/tmp/timeFile","w")
    f:write("test")
    f:close()
    return(require("filesystem").lastModified("/tmp/timeFile"))
  end
  local realTimeOld = time()
  os.sleep(2)
  return 40000 / (time() - realTimeOld)
end

return tps
