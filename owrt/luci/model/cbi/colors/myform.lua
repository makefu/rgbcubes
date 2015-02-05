m = Map("colors","Configure RGB Cube Colors")

s = m:section(TypedSection,"colors","")
s.anonymous=true
s:option(Flag,"enabled","LEDs enabled").rmempty=false

p = s:option(ListValue,"mode","Current Mode")
p:value("rainbow","Rainbow")
p:value("white","White Light")
p:value("random","Random Lights")

return m
