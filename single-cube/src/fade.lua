local M = {}
c = require('config')
local tmrid = 1
local fade_delay = 2000
local fade_steps = fade_delay / 10
local currentBuffer = nil

function M.init(numLed)
  -- init will create a new buffer and fill it with the off color
  currentBuffer = ws2812.newBuffer(numLed)
  local off = c.state.off_color
  currentBuffer:fill(off[2],off[1],off[3])
  currentBuffer:write(4)
end

function M.get_buffer()
  return currentBuffer
end

function M.set_delay(delay)
  fade_delay = delay
  fade_steps = delay / 10
end

function M:fade_color(rgb)
  -- fades to a single color
  -- rgb = {r,g,b}
  local nb = ws2812.newBuffer(c.state.numled)
  r = rgb[1]
  g = rgb[2]
  b = rgb[3]
  nb:fill(g,r,b)
  self.fade(nb)
end

function M:adjust_brightness(color)
 -- change the brightness of a single color
 -- compensate for non-linear brightness
	color = math.floor(color/100*(c.state.brightness^3/10000), 0)
	return color
end

function M.fade(nextBuffer)
  if not currentBuffer then
    print("ERROR: run <fade>.init(numle) first")
    return
  end
  local size = currentBuffer:size()
  local firstBuffer = ws2812.newBuffer(size)

  local current_step = 1
  local step_delay = fade_delay / fade_steps

  if not (size == nextBuffer:size()) then
    print('Error: current and next buffer size differ!')
    return 1
  end

  local function run_fade()
    if current_step >= fade_steps then
        -- stop self
        -- print('Debug: stopping fade')
        tmr.stop(tmrid)
    end

    -- implement logarithmic decay
    local previous_weight = 100 * (fade_steps - current_step);
    local current_weight = 100 * (current_step - 1);
    local fade_weight = 100 * (fade_steps - 1);
    -- send this fade step to the led interface
    for i=0,size-1,1 do
      local cg,cr,cb = firstBuffer:get(i)
      local ng,nr,nb = nextBuffer:get(i)
      local g = (((ng * current_weight) + (cg * previous_weight)) / fade_weight)
      local r = (((nr * current_weight) + (cr * previous_weight)) / fade_weight)
      local b = (((nb * current_weight) + (cb * previous_weight)) / fade_weight)
      currentBuffer:set(i,g,r,b)
    end

    currentBuffer:write(4)
    current_step = current_step + 1
  end
  -- copy buffer
  for i=0,size-1,1 do
    local g,r,b = currentBuffer:get(i)
    firstBuffer:set(i,g,r,b)
  end

  tmr.stop(tmrid)
  -- print('Debug: starting fade')
  tmr.alarm(tmrid,step_delay,1,run_fade)
end

return M
