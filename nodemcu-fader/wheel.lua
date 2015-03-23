-- until we can use Math.floor
function myfloor(n)
  return n - (n %1 )
end
-- local floor = Math.floor
local floor = myfloor
-- stolen from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
-- Assumes h, s, and v are contained in the set [0, 1] and
-- returns r, g, and b in the set [0, 255].
function hsvToRgb(h, s, v)
  local r, g, b
  local i = floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);
  i = i % 6
  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end
  return r * 255, g * 255, b * 255
end
fader = require('fade')
fader.loop.on_finished(change_wheel)

-- fast fade to black, then start wheel
fader.fade_pixel(string.char(0,0,0):rep(numLED),1,1)

local numLED = 12
local hue = 0
local hue_step= 1/numLED
local fade_time=2000
local fade_steps=200
function change_wheel()
  local buffer = ""
  for i=1,numLED,1 do
    -- 1 => max hue value
    local hv=(hue+(i*hue_step))%1
    r,g,b=hsvToRgb(hv,1,1)
    print(i,hv,r,g,b)
    buffer = buffer .. string.char(r,g,b)
  end
  hue = (hue +  hue_step) %1
  print(hue)
  fader.fade_pixel(buffer,fade_time,fade_steps)
end
