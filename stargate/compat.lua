-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

function try(func, ...)
  ok, result = pcall(func, ...)
  if not ok then
    print("Error: " .. result)
  end
end

function check(...)
  values = {...}
  if values[1] == nil then
    error(values[2], 0)
  end
  return ...
end

screen_width, screen_height = gpu.getResolution()
max_Bildschirmbreite, max_Bildschirmhoehe = gpu.maxResolution()

function setCursor(col, row)
  term.setCursor(col, row)
end

function write(s)
  term.write(s)
end

function pull_event()
  if state == "Idle" and checkEnergy == energy then
    checkEnergy = energy
    return event.pull(300)
  else
    checkEnergy = energy
    return event.pull(1)
  end
end

key_event_name = "key_down"

function key_event_char(e)
  return string.char(e[3])
end
