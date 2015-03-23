-- wifi.setmode(wifi.STATION)
-- wifi.sta.config("127.0.0.1","lolwut8internet")

srv=net.createServer(net.TCP)
local f = require('fade')
local char=string.char

local handle_request=dofile('fun.lua')

srv:listen(80,function(conn) 
    conn:on("receive", handle_request)
end)

