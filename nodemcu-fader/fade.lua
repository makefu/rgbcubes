
-- TODO: make this a module which exports the last current rgb array

local delay_loop = require('delay_loop')
local ws2812= require('ws2812')

--local moduleName = 'fade'
local moduleName = ...
-- _G[moduleName] = M


-- local buffer= {}
-- local pin=7
local M = {}
M.__index = M

function M.new(pin,numLED)
    local self=setmetatable({},M)
    self.pin=pin
    self.buffer={}
    self.tbuf=""
    self:reset(numLED)
    return self
end


local function log(x)
    local n = 1000.0
    return n * ((( x ^( 1/n)) ) - 1)
end

function M:write(buf)
  self.buffer=buf
  self:show()
end

function M:show()
  local tbuffer=""
  for k,v in pairs(self.buffer) do
    tbuffer=tbuffer..string.char(v[1],v[2],v[3])
  end
  if not(tbuffer == self.tbuf)then
      ws2812.write(self.pin,tbuffer)
      self.tbuf = tbuffer
  end
end

function M:reset(numLED)
  -- not required but provides baseline
  for i=1,numLED,1 do
    self.buffer[i]={0,0,0}
  end
  self:show()
  collectgarbage()
end

local function copy_buffer(b)
  local n = {}
  for k,v in pairs(b) do
    n[k]={}
    for bi,bv in pairs(v) do
      n[k][bi]= bv
    end
  end
  return n
end

function M:stop()
  tmr.stop(1)
end

function M:fade(to_array,fader_delay,fader_steps)
  local from_array = copy_buffer(self.buffer)
  local step_delay = ( fader_delay )/ fader_steps
  local log_base = log(fader_steps)
  self:stop()

  local function run_fade(current_step)
    local previous_weight
    local current_weight
    local fader_weight
    -- this only implements logarithmic decay
    current_weight = 100 - ( 100 * (log(fader_steps - current_step + 1) / log_base))
    previous_weight = 100 - ( 100 * (log(current_step) / log_base))
    fader_weight = current_weight + previous_weight
    -- send this fader step to the led interface
    for i=1,#to_array,1 do
      if not from_array[i] then from_array[i] = {0,0,0} end

      local r = ( ( (to_array[i][1] * current_weight)+(from_array[i][1] * previous_weight) ) / fader_weight )
      local g = ( ( (to_array[i][2] * current_weight)+(from_array[i][2] * previous_weight) ) / fader_weight )
      local b = ( ( (to_array[i][3] * current_weight)+(from_array[i][3] * previous_weight) ) / fader_weight )

      self.buffer[i] = {r,g,b}
    end
    self:show()
  end
  --         start,max_steps,increment,delay,callback
  delay_loop(1,fader_steps,1,step_delay,run_fade)
end

return M
