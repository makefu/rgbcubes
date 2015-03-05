
-- api
-- 


function log(x)
    n = 1000.0
    return n * ((( x ^( 1/n)) ) - 1)
end

function fade_pixel(from_array,to_array,fader_delay,fader_steps)
  local NumLEDs = #from_array
  local step_delay = fader_delay / fader_steps
  local log_base = log(fader_steps)
  for current_step=1,fader_steps,1 do
    local previous_weight
    local current_weight
    -- this only implements logarithmic decay
    current_weight = 100 - ( 100 * (log(fader_steps - current_step + 1) / log_base))
    previous_weight = 100 - ( 100 * (log(current_step) / log_base))
    fader_weight = current_weight + previous_weight
    -- send this fader step to the led interface
    for i=1,NumLEDs,1 do
      local r = ( ( (to_array[i][1] * current_weight)+(from_array[i][1] * previous_weight) ) / fader_weight )
      local g = ( ( (to_array[i][2] * current_weight)+(from_array[i][2] * previous_weight) ) / fader_weight )
      local b = ( ( (to_array[i][3] * current_weight)+(from_array[i][3] * previous_weight) ) / fader_weight )
      print(r,g,b)
    end
    -- tmr.delay(step_delay)
  end

end

fade_pixel({{0,0,0},{0,0,0}},{{255,255,255},{255,255,255}},1000,500)
--  for (int current_step = 1; current_step <= fader_steps; current_step++) {
--    // Send this fader step to the LED interface
--    for (int i = 0; i < NumLEDs; i++) {
--      // fader_cache == LEDs 
--      // PixelBuffer == future LEDs
--      LEDs[i] = CRGB(
--      int(((PixelBuffer[i][0] * current_weight) + (fader_cache[i][0] * previous_weight)) / fader_weight),
--      int(((PixelBuffer[i][1] * current_weight) + (fader_cache[i][1] * previous_weight)) / fader_weight),
--      int(((PixelBuffer[i][2] * current_weight) + (fader_cache[i][2] * previous_weight)) / fader_weight)
--      );
--    }
--    FLED.show();
--    // Pause for a fraction of a moment
--    delay(step_delay);
--  }
--  return *this;
--}u
