current_leds=""

local char=string.char

function derp (client,request)
  local buf = "";
  local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
  local _,_,payload= string.find(request,'\r\n\r\n(.*)')
  if(method == nil)then 
      _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP"); 
  end
  local _GET = {}
  if (vars ~= nil)then 
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do 
          _GET[k] = v 
      end 
    end
  print(method,path,vars)
  print(payload)
  print()
  print(buf)
end


client='none'
request="GET /fade HTTP\r\nContent-Type: text/html\r\n\r\nmy-payload"

derp(client,request)
