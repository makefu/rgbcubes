current_leds={}
wifi.setmode(wifi.STATION)
wifi.sta.config("127.0.0.1","lolwut8internet")
srv=net.createServer(net.TCP)
local f = require('fade')
local char=string.char
srv:listen(80,function(conn) 
    conn:on("receive", function(client,request)
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
        client:send("HTTP/1.1 200 OK\r\n")
        client:send("Content-Type: text/html\r\n")
        client:send("Connection: close\r\n")
        client:send("\r\n")
        collectgarbage();
        buf = buf.."<h1> Hello, NodeMcu.</h1>"
        local color = _GET.color
        if color then
            buf = buf .. "<p>You have selected:<b>".. _GET.color .."</b></p>"
        end
        new_leds = false
        if  color == 'RED' then
            new_leds=char(0,128,0,0,128,0,0,128,0)
        elseif color =='BLUE' then
            new_leds=char(0,0,128,0,0,128,0,0,128)
        elseif color =='GREEN' then
            new_leds=char(128,0,0,128,0,0,128,0,0)
        elseif color =='RGB' then
            new_leds=char(128,0,0,0,128,0,0,0,128)
        elseif color =='BLACK' then
            new_leds=char(0,0,0,0,0,0,0,0,0)
        end
        if new_leds then
            buf = buf.."<p>beginning to fade</p>"
            f.fade(new_leds,1000,500)
        end
        if color and not(new_leds)then
            buf = buf.."<p>Color not configured, sorry</p>"
        end

        buf = buf.."<form src=\"/\">Fade LED<select name=\"color\" onchange=\"form.submit()\">";
        buf = buf.."<option></option><option>BLACK</opton><option>RED</opton><option>BLUE</option><option>GREEN</option><option>RGB</option></select></form>";
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)

