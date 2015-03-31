function log(x)
    n = 1000.0
    return n * ((( x ^( 1/n)) ) - 1)
end
local loop=require('loop')
local buffer=""
local pin=4
local function fade_pixel(to_array,fader_delay,fader_steps)
  local from_array=buffer
  local NumLEDs = #to_array
  local step_delay = fader_delay / fader_steps
  local log_base = log(fader_steps)

  local function run_fade(current_step)
    local previous_weight
    local current_weight
    local rgb_buffer
    -- this only implements logarithmic decay
    current_weight = 100 - ( 100 * (log(fader_steps - current_step + 1) / log_base))
    previous_weight = 100 - ( 100 * (log(current_step) / log_base))
    local fader_weight = current_weight + previous_weight
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
      buffer = buffer .. string.char(r,g,b)
    end
    rgb_buffer=buffer..string.char(0,0,0)
    print("rgb before",rgb_buffer:byte(1,9))
    print("buf before",buffer:byte(1,9))
    ws2812.writergb(pin,rgb_buffer)
    print("rgb after",rgb_buffer:byte(1,9))
    print("buf after",buffer:byte(1,9))
  end

  loop.stop()
  loop.start(1,fader_steps,1,step_delay,run_fade)

end
local function get_buffer()
    return buffer
end

return {fade=fade_pixel,buffer=get_buffer,looper=loop}
