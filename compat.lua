--
--   Library code
--

term = require("term")
event = require("event")
gpu = component.getPrimary("gpu")

--   Utility for calling a function and printing the
--   error message if it throws an exception

function try(func, ...)
  ok, result = pcall(func, ...)
  if not ok then
    print("Error: " .. result)
  end
end

--   Terminal API compatibility functions

screen_width, screen_height = gpu.getResolution()

function setCursor(col, row)
  term.setCursor(col, row)
end

function write(s)
  term.write(s)
end

--   Event API compatibility functions

function pull_event()
  if state == "Idle" and energy >= 4000000 then
    return event.pull()
  else
    return event.pull(0.1)
  end
end

key_event_name = "key_down"

function key_event_char(e)
  return string.char(e[3])
end
