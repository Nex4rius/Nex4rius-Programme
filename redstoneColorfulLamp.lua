component = require("component")
event = require("event")
r = component.getPrimary("redstone")
Richtung = 0

a = true

function rot()
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 9, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gelb()
  for i = 14, 4, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function orange()
  for i = 9, 14 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 8, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function gruen()
  for i = 9, 5, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
  for i = 4, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
  for i = 14, 10, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function weiss()
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function schwarz()
  for i = 14, 0, -1 do
    r.setBundledOutput(Richtung, i, 0)
  end
end

function redstone()
end

weiss()

--while a do
--for a = 0, 20 do
  --redstone()
  --event.pull(300)
--end

print("weiss")
weiss()
os.sleep(2)
print("rot")
rot()
os.sleep(2)
print("gelb")
gelb()
os.sleep(2)
print("orange")
orange()
os.sleep(2)
print("gruen")
gruen()
os.sleep(2)
print("schwarz")
schwarz()
