-- original from ATastyPeanut https://github.com/ATastyPeanut/OpenComputers-Minecraft-Lua
-- modified by Nex4rius

local com = require("component")
local fs = require("filesystem")

local timeConstant = 2

local function time()
  local f = io.open("/tmp/timeFile","w")
  f:write("test")
  f:close()
  return(fs.lastModified("/tmp/timeFile"))
end

local realTimeOld = 0
local realTimeNew = 0
local realTimeDiff = 0

local TPS = {}
local avgTPS = 0

for tSlot=1,10 do
  TPS[tSlot]=0
end

while true do
  for tSlot = 1, 10 do
    realTimeOld = time()
    os.sleep(timeConstant)
    realTimeNew = time()

    realTimeDiff = realTimeNew-realTimeOld
		
    TPS[tSlot] = 20000*timeConstant/realTimeDiff
    avgTPS = (TPS[1]+TPS[2]+TPS[3]+TPS[4]+TPS[5]+TPS[6]+TPS[7]+TPS[8]+TPS[9]+TPS[10])/10
    gpu.set(2,5,"Server is running at:")
    gpu.set(3,6,string.sub(tostring(TPS[tSlot])..".0000",1,7).." Ticks/second                                                ")
    gpu.set(2,8,"Averaged value is:")
    gpu.set(3,9,string.sub(tostring(avgTPS)..".0000",1,7).." Ticks/second                                                ")
    histoPlot(TPS,leftX,topY,tSlot)
  end
end
