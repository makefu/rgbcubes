local tmr = tmr
local tmrid=1
local buffer=""
local pin=1

local function fade_pixel(to_array,fader_delay,fader_steps)
  local from_array=buffer
  local NumLEDs = #to_array
  local current_step=1
  local step_delay = fader_delay / fader_steps
  
  local function run_fade()
    
    if current_step >= fader_steps then
        -- stop self
        -- print('stopping timer')
        tmr.stop(tmrid)
        
    end
    local previous_weight
    local current_weight
    
    -- this only implements logarithmic decay
    previous_weight = 100 * (fader_steps - current_step);
    current_weight = 100 * (current_step - 1);
    local fader_weight = 100 * (fader_steps - 1);

    -- send this fader step to the led interface
    buffer=""
    for i=1,NumLEDs,3 do
      if not from_array:byte(i) then from_array =from_array.. string.char(0,0,0) end

      local g = ( ( (to_array:byte(i) * current_weight)+
                (from_array:byte(i) * previous_weight) ) / fader_weight )
      local r = ( ( (to_array:byte(i+1) * current_weight)+
                (from_array:byte(i+1) * previous_weight) ) / fader_weight )
      local b = ( ( (to_array:byte(i+2) * current_weight)+
                (from_array:byte(i+2) * previous_weight) ) / fader_weight )
      buffer = buffer .. string.char(g,r,b)
    end
    ws2812.write(pin,buffer)
    current_step = current_step + 1
    tmr.wdclr()
  end
    
  tmr.stop(tmrid)
  --print('begin run_fade')
  tmr.alarm(tmrid,step_delay,1,run_fade)

end
local function get_buffer()
    return buffer
end
local function set_ledpin(newpin)
    pin = newpin
end
local function get_ledpin()
    return pin
end


return {fade=fade_pixel,buffer=get_buffer,
        set_ledpin=set_ledpin,ledpin=get_ledpin}
