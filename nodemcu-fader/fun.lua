


local function handle_request(client,request)
   local buf = "";
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
   if (method == POST) then
       _,_,data = string.find(request,"\r\n\r\n(.*)")
   end
   client:send("HTTP/1.1 200 OK\r\n")
   client:send("Content-Type: text/html\r\n")
   client:send("Connection: close\r\n")
   client:send("\r\n")
   --  end preprocessing

   if path == '/fade' then

   end

   collectgarbage();
   buf = buf.."<h1> Hello, NodeMcu.</h1>"

   client:send(buf);
   client:close();
   collectgarbage();
end

return handle_request
