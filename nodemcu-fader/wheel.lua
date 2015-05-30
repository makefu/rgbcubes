-- until we can use Math.floor
--local function myfloor(n)
--  return n - (n %1 )
--end


-- local floor = Math.floor
local floor = math.floor
-- stolen from https://github.com/EmmanuelOga/columns/nodemcu-faderblob/master/utils/color.lua
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

local numLED = 16





local hue = 0 -- the current hue value, gets changed by functions
local brightness = 1 
local hue_step= 0.002

local ledpin=1
local cols=4
local rows=4

local function inv(buf)
    local nbuf=""
    
    for i=1,#buf,3 do
        nbuf =  buf:sub(i,i+2) .. nbuf
    end
    return nbuf
end
local function change_wave(color_space)
    
    -- a single step for a wave for the leds
    local buf="" -- the final buffer
    -- it only makes sense to use the color space between 0 and 1
    local led_step = color_space/cols
    for j=1,cols,1 do
        local hv=(hue+(j*led_step))%1
        r,g,b=hsvToRgb(hv,1,1)
        buf = buf.. string.char(r*brightness,g*brightness,b*brightness)
    end
    
    invbuf = inv(buf)
    buf = (buf..invbuf):rep(2)
    
    hue = (hue +  hue_step) %1
    ws2812.writergb(ledpin,buf)
    buf=nil
    tmr.wdclr()
end
local function change_wheel()
  local buf = ""
  local led_step = 1/numLED 
  -- 1/numLED  : the whole color wheel with the LEDs we have
  -- 2/numLED : the half of the color wheel
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
  buf=nil
  tmr.wdclr()
end

local function get_hue()
  return hue
end
local function set_brightness(br)
  brightness=br
end

return {wheel=change_wheel,wave=change_wave,get_hue=get_hue,set_brightness=set_brightness}
