
local c = require('config')
local s = require('run_state')


local function handle_request(client,request)
   local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
   if(method == nil)then 
       _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP"); 
   end
   local _GET = {}
   if (vars ~= nil)then 
       for k, v in string.gmatch(vars, "(%w+)=([%w.]+)&*") do 
           _GET[k] = v 
       end 
   end
   
   client:send("HTTP/1.1 200 OK\r\n")
   client:send("Content-Type: text/html\r\n")
   client:send("Connection: close\r\n")
   client:send("\r\n")
   --  end preprocessing
        
   if path == '/on' then
        client:send("LEDs are now on")
        s.run_state("on")
        
   elseif path == '/off' then
        buf = "LEDs are now off"
        s.run_state("off")
   elseif path == '/brightness' then
        if _GET.val then
            local data= _GET.val
            client:send("setting brighyness to "..data)
            s.run_state("brightness",tonumber(data))
        else
            client:send("please provide GET 'val' - cannot set brightness")
        end
   elseif path == '/single' then
        local r = tonumber(_GET.r or 0)
        local g = tonumber(_GET.g or 0)
        local b = tonumber(_GET.b or 0)
        client:send("setting LEDS to ("..r..","..g..","..b..")")
        s.run_state("single",string.char(g,r,b))
   elseif path == '/status' then
        client:send(cjson.encode(c.state))
   elseif path == '/defaults' then
        client:send(cjson.encode(c.defaults))
   else 
        client:send("unknown path "..path)
   end

   client:close()
   collectgarbage()
end

s.run_state("off")

srv=net.createServer(net.TCP,1)
srv:listen(80,function(conn) 
    conn:on("receive", handle_request)
end)
