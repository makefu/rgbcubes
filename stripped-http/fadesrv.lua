-- uses:
-- default_buf
-- buf
-- ledpin

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

   function send_file(f)
     file.open(f,"r")
     block = file.read(1024)
     while block do
       client:send(block)
       block = file.read(1024)
     end
     file.close()
   end
   if path == '/' then
        local ip,_,_=wifi.sta.getip()
        send_file('head.html')

        client:send("<div class='list-group'>")
        function send_item(a,b)
                client:send(string.format(
            "<a href='#' class='list-group-item'>%s: <b>%s</b></a>",
            a,b))
        end
        send_item("IP",ip)
        send_item("MAC",wifi.sta.getmac())
        send_item("Uptime",
              string.format("%d seconds",tmr.time()))
        client:send("</div>")
        send_file('end.html')
   elseif path == '/code.js' then
        send_file('code.js')
   elseif path == '/on' then
        client:send("LEDs are now on")
        buf = default_buf
        ws2812.write(ledpin,buf)
   elseif path == '/off' then
        buf = "LEDs are now off"
        buf=string.char(0,0,0):rep(numled)
        ws2812.write(ledpin,buf)
   elseif path == '/color' then
        local r = tonumber(_GET.r or 0)
        local g = tonumber(_GET.g or 0)
        local b = tonumber(_GET.b or 0)
        client:send("setting LEDS to ("..r..","..g..","..b..")")
        buf = string.char(g,r,b):rep(numled)
        ws2812.write(ledpin,buf)
   elseif path == '/restart' then
        client:send("bye")
        node.restart()
   else
        client:send("unknown path "..path)
   end

   client:close()
   collectgarbage()
end

srv=net.createServer(net.TCP,1)
srv:listen(80,function(conn)
    conn:on("receive", handle_request)
end)
