-- until we can use Math.floor
local function myfloor(n)
  return n - (n %1 )
end
-- local floor = Math.floor
local floor = myfloor
-- stolen from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
-- Assumes h, s, and v are contained in the set [0, 1] and
-- returns r, g, and b in the set [0, 255].
local function hsvToRgb(h, s, v)
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
-- fast fade to black, then start wheel
local numLED = 6

local hue = 0
local led_step= 1/numLED
local brightness = 1 
local hue_step= 0.002
local fade_time=200
local fade_steps=100
local ledpin=4

local function change_wheel()
  local buf = ""
  for i=1,numLED,1 do
    -- 1 => max hue value
    local hv=(hue+(i*led_step))%1
    r,g,b=hsvToRgb(hv,1,1)
    -- print(i,hv,r,g,b)
    buf = buf .. string.char(r*brightness,g*brightness,b*brightness)
  end
  hue = (hue +  hue_step) %1
  -- print(hue)
  ws2812.writergb(ledpin,buf)
end

local function get_hue()
  return hue
end
local function set_brightness(br)
  brightness=br
end
return {wheel=change_wheel,get_hue=get_hue,set_brightness=set_brightness}
