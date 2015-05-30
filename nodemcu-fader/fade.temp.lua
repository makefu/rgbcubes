local loop=require('loop')
local buffer=""
local pin=4
local function fade_pixel(to_array,fader_delay,fader_steps)
  local from_array=buffer
  -- numLEDs is the number of total leds, (3 for each ws2812)
  local NumLEDs = #to_array
  local step_delay = fader_delay / fader_steps

  local function run_fade(current_step)

    local previous_weight
    local current_weight
    -- this only implements logarithmic decay
    -- print(node.heap())
    -- --
    -- print(fader_steps)
    -- print(current_step)
    local previous_weight = 100 * (fader_steps - current_step);
    -- print(previous_weight)
    local current_weight = 100 * (current_step - 1);
    -- print(current_weight)
    local fader_weight = 100 * (fader_steps - 1);
    -- print(fader_weight)
    -- send this fader step to the led interface
    buffer=""
    for i=1,NumLEDs,3 do
      if not from_array:byte(i) then from_array =from_array.. string.char(0,0,0) end
      local r = ( ( (to_array:byte(i) * current_weight)+
                  (from_array:byte(i) * previous_weight) ) / fader_weight )
      local g = ( ( (to_array:byte(i+1) * current_weight)+
                  (from_array:byte(i+1) * previous_weight) ) / fader_weight )
      local b = ( ( (to_array:byte(i+2) * current_weight)+
                  (from_array:byte(i+2) * previous_weight) ) / fader_weight )
      -- print(r,g,b)
      buffer = buffer .. string.char(r,g,b)
    end
    ws2812.writergb(pin,buffer)
  end
  loop.stop()
  loop.start(1,fader_steps,1,step_delay,run_fade)

end
local function get_buffer()
    return buffer
end

return {looper=loop,fade=fade_pixel,buffer=get_buffer}
