-- original from ATastyPeanut https://github.com/ATastyPeanut/OpenComputers-Minecraft-Lua
-- modified by Nex4rius

local com = require "component"
local fs = require "filesystem"
local keyboard = require "keyboard"
local gpu = com.gpu	

local leftX = 5
local topY = 14
local timeConstant = 2 --how long it waits per measure cycle

local w, h = gpu.getResolution()
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1, 1, w, h, " ") -- clears the screen
gpu.set(2,2,"Will measure TPS with wait period of "..tostring(timeConstant).." seconds...                                                ")

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

local function getColor(tps) --Uses HSV to decide color
	local H, rP, gP, bP, X = tps*12-120, 0, 0, 0, 0
	--H is hue should range from 0 to 120
	if H<0 then H=0 end --forces greater then 0 but if things get wonky lets Hue go above 120 and turn blue
	X = (1-math.abs((H/60)%2-1))
	if H<60 then
		rP = 1
		gP = X
		bP = 0
	elseif H<120 then
		rP = X
		gP = 1
		bP = 0	
	elseif H<180 then
		rP = 0
		gP = 1
		bP = X	
	elseif H<240 then
		rP = 0
		gP = X
		bP = 1	
	elseif H<300 then
		rP = X
		gP = 0
		bP = 1
	else
		rP = 1
		gP = 0
		bP = X
	end
	return(math.floor((rP)*255)*65536+math.floor((gP)*255)*256+math.floor((bP)*255))
end

local function histoPlot(tabVal,leftX, topY,step)
	local height = math.floor(tabVal[step]/2)+1
	if height>11 then height=11 end
	gpu.setBackground(0xB4B4B4)
	gpu.fill(3*step+leftX-2, topY-2, 2, 13," ")  --erases the old TPS bar
	gpu.fill(leftX-1,topY+10,33,1," ") --erases the old blue box
	gpu.setBackground(getColor(tabVal[step]))
	gpu.fill(3*step+leftX-2, topY-height+10, 2, height," ") --draws the TPS bar
	gpu.setBackground(0x0064FF)
	gpu.fill(leftX+step*3-2,topY+10,2,1," ") --the blue box that marks where we are on the graph
	gpu.setBackground(0x000000)
end

gpu.set(2,3,"To exit hold down Ctrl + W                                                ")

gpu.setBackground(0xB4B4B4)  --draws the nice grey graph background
gpu.fill(leftX-1,topY-2,33,13," ")
gpu.setBackground(0x000000)

for i = 1,#TPS do --draws the first red bars to make something looking like a graph
	local height = math.floor(TPS[i]/2)+1
	gpu.setBackground(getColor(TPS[i]))
	gpu.fill(3*i+leftX-2, topY-height+10, 2, height," ")
end
gpu.setBackground(0x000000)
gpu.set(18,11,"T/s")
gpu.set(1,12,"20")
gpu.set(1,17,"10")
gpu.set(1,22," 0")
for i=1, math.huge do
	for tSlot = 1, 10 do --main averaging loop that measures individual TPS and puts it into a cycling table location
		realTimeOld = time()
		os.sleep(timeConstant) --waits for an estimated ammount game seconds
		realTimeNew = time()

		realTimeDiff = realTimeNew-realTimeOld
		
		TPS[tSlot] = 20000*timeConstant/realTimeDiff
		avgTPS = (TPS[1]+TPS[2]+TPS[3]+TPS[4]+TPS[5]+TPS[6]+TPS[7]+TPS[8]+TPS[9]+TPS[10])/10
		gpu.set(2,5,"Server is running at:")
		gpu.set(3,6,string.sub(tostring(TPS[tSlot])..".0000",1,7).." Ticks/second                                                ")
		gpu.set(2,8,"Averaged value is:")
		gpu.set(3,9,string.sub(tostring(avgTPS)..".0000",1,7).." Ticks/second                                                ")
		histoPlot(TPS,leftX,topY,tSlot)
		if keyboard.isKeyDown(keyboard.keys.w) and keyboard.isControlDown() then
			gpu.set(2,11,"Exiting...                                                ")
			os.sleep(0.5)
			gpu.fill(1, 1, w, h, " ") -- clears the screen
			os.exit()
		end
	end
end
