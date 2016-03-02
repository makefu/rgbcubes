-- uses:
-- default_buf
-- buf
-- ledpin
c = require('config')
f = require('fade')
print("fadesrv:debug: init")
f.init(c.state.numled)
f.set_delay(c.state.fadedelay)

local function handle_request(client,request)
   -- print("fadesrv:debug: got connection")
   local response = {
     "HTTP/1.1 200 OK\r\n",
     "Content-Type: text/html\r\n",
     "Access-Control-Allow-Origin: *\r\n",
     "Connection: close\r\n",
     "\r\n" }

   local function add(txt)
     table.insert(response,txt)
   end

   local function sender (client)
     if #response>0 then
        client:send(table.remove(response,1))
     else
        -- print("fadesrv: closing connection")
        client:close()
     end
   end

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

   --  end preprocessing

   local function send_file(f)
     file.open(f,"r")
     local block = file.read(1024)
     while block do
       add( block )
       block = file.read(1024)
     end
     file.close()
   end

   if path == '/' then
        local ip,_,_=wifi.sta.getip()
        send_file('static/head.html')
        add("<div class='list-group'>")
        function send_item(a,b)
                add(string.format(
            "<a href='#' class='list-group-item'>%s: <b>%s</b></a>\n",
            a,b))
        end
        send_item("IP",ip)
        send_item("MAC",wifi.sta.getmac())
        send_item("Uptime",
              string.format("%d seconds",tmr.time()))
        send_item("Heap",
              string.format("%d bytes",node.heap()))
        add("</div>")
        send_file('static/end.html')

   elseif path == '/code.js' then
        send_file('static/code.js')
   elseif path == '/on' then
        local nb = ws2812.newBuffer(c.state.numled)
        nb:fill(255,255,255)
        f.fade(nb)
        add("LEDs are now on")
   elseif path == '/off' then
        -- TODO
        local nb = ws2812.newBuffer(c.state.numled)
        nb:fill(0,0,0)
        f.fade(nb)
        add("LEDs are now off")
   elseif path == '/save' then
        add("saving config")
        c:save()
   elseif path == '/fadedelay' then
        local delay =  tonumber(_GET.ms or c.state.fadedelay)
        add("setting fade delay to ".. delay)
        f.set_delay(delay)
        c.state.fadedelay = delay
   elseif path == '/color' then
        local nb = ws2812.newBuffer(c.state.numled)
        local r = tonumber(_GET.r or 0)
        local g = tonumber(_GET.g or 0)
        local b = tonumber(_GET.b or 0)
        nb:fill(g,r,b)
        f.fade(nb)
        add("setting LEDS to ("..r..","..g..","..b..")")
   elseif path == '/restart' then
        add("bye")
        node.restart()
   else
         add("unknown path "..path)
   end
   -- print("starting sender")
   client:on("sent", sender)
   sender(client)
   -- collectgarbage()
end

srv=net.createServer(net.TCP,30)
srv:listen(80,function(conn)
    conn:on("receive", handle_request)
end)
