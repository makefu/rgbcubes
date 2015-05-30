x = dofile('wheel.lua')
tmr.alarm(1,50,1,function () x.wheel() end)