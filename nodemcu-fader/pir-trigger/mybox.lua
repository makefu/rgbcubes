sk = net.createConnection(net.TCP, 0)
-- sk:connect(80,"mybox.connector.one")

print ("updating mybox.connector.one")
sk:connect(80,"195.154.108.70")
sk:on("connection", function(sck,c)
    local ip,_,_ = wifi.sta.getip()
    local len = tostring(ip:len())
    local data = "POST / HTTP/1.1\r\nHost: mybox.connector.one\r\nContent-length: ".. len .."\r\nContent-Type: application/json\r\n\r\n" .. ip .. "\r\n"
    sck:send(data)
end)
sk = nil
