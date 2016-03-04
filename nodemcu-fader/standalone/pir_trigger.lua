c = require('config')
f = require('fade')
local pir_pin = c.state.pir_pin or 2
gpio.mode(pir_pin,gpio.INPUT,gpio.PULLUP)

local function check_alarm ()
  -- TODO only start timer if pir is requested
  if c.state.mode == "pir" then
    local pir_status = gpio.read(pir_pin)
    --print("PIR Status:"..pir_status)
    if pir_status then
      --print("starting up LEDs")
      f:fade_color(c.state.on_color)
    else
      --print("shutting down LEDs")
      f:fade_color(c.state.off_color)
    end
  end
end


print("Enabling PIR on pin "..pir_pin)
tmr.alarm(6,c.state.pir_timeout or 3000,tmr.ALARM_AUTO,check_alarm)

