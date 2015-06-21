ws2812.write(1,string.char(0,0,255):rep(10))
=ws2812.brightness()
=ws2812.set_brightness(1)
=ws2812.set_brightness(0.005)

a=require('config')
a:save()
=a.conf
=a.state
a.state.dick="butt"
t=a.state

a.state.pin=3
collectgarbage()