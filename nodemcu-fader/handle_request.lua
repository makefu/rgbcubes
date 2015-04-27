local s = require('run_state')

local function handle_request(client,request)
   local buf = ""
   local data=""
   local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
   if(method == nil)then 
       _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP"); 
   end
   local _GET = {}
   if (vars ~= nil)then 
       for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do 
           _GET[k] = v 
       end 
   end
   if (method == "POST") then
       -- TODO: multi-chunk requests are not supported
       _,_,data = string.find(request,"\r\n\r\n(.*)")
       print("data: "..data)
   end
   
   client:send("HTTP/1.1 200 OK\r\n")
   client:send("Content-Type: text/html\r\n")
   client:send("Connection: close\r\n")
   client:send("\r\n")
   --  end preprocessing


   if path == '/fade' then
        
        nbuf = "beginning to fade to " .. data
        buf = cjson.encode({msg=nbuf})
        
   elseif path == '/on' then
        
        buf = "LEDs are now on"
        s.set_state("on")
        
   elseif path == '/off' then
        
        buf = "LEDs are now off"
        s.set_state("off")
   elseif path == '/brightness' then
        
        if _GET.val then
            local data = _GET.val
            buf = "setting brighness to "..data
            s.set_state("brightness",tonumber(data))
        else
            buf="cannot set brightness"
        end
   elseif path == '/set' then
        s.set_state("static",data)
   elseif path == '/all' then
        local r = tonumber(_GET.r or 0)
        local g = tonumber(_GET.g or 0)
        local b = tonumber(_GET.b or 0)
        s.set_state("all",string.char(r,g,b))
   else 
        buf = "unknown path "..path
   end

   client:send(buf);
   client:close();
   collectgarbage();
end

return handle_request
