srv=net.createServer(net.TCP,1)


local s = require('run_state')
s.set_state("off")
local handle_request = require('handle_request')
srv:listen(80,function(conn) 
    conn:on("receive", handle_request)
end)
