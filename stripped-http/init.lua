-- servo
-- gpio.mode(2,gpio.OUTPUT)



wifi.setmode(wifi.STATION)
wifi.sta.config("shack","welcome2shack")
numled=3
buf=string.char( 255,0, 0):rep(numled)

default_buf = buf
ledpin=1


ws2812.write(1,buf)
dofile("fadesrv.lc")