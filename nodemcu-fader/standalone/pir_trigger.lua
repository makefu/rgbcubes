local pir_pin = 2
gpio.mode(pir_pin,gpio.INPUT,gpio.PULLUP)

local function check_alarm ()
  print("Pin Status:"..gpio.read(pir_pin))
end

tmr.alarm(6,5000,tmr.ALARM_AUTO,check_alarm)

