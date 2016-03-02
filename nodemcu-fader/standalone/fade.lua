local M = {}
local tmrid = 1
local fade_delay = 2000
local fade_steps = fade_delay / 10
local currentBuffer = nil

function M.init(numLed)
  currentBuffer = ws2812.newBuffer(numLed)
  currentBuffer:fill(0,0,0)
  currentBuffer:write(4)
end

function M.get_buffer()
  return currentBuffer
end

function M.set_delay(delay)
  fade_delay = delay
  fade_steps = delay / 10
end

function M.fade(nextBuffer)
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
