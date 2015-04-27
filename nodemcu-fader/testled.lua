f=require('fade')
k= string.char(255,0,0,0,255,0,0,0,255)
l = string.char(0,0,0,0,0,0,0,0,0)
f.fade(l,1000,200)
ws2812.writergb(3,string.char(255,0,0):rep(3))
ws2812.writergb(3,string.char(0,255,0):rep(3))
x = require('run_state')
x.pin=4