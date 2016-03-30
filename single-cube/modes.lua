local hue = 0 -- the current hue value, gets changed by functions
local hue_step = 0.002

local f = require('fade')
local c = require('config')

local function floor(i)
    return i-(i%1)
end

local function hsv2rgb(h,s,v)
    local r,g,b
    local i=floor(h*6)
    local f=h*6-i
    local p=v*(1-s)
    local q=v*(1-f*s)
    local t=v*(1-(1-f)*s)
    i=i%6
    if i==0 then r,g,b=v,t,p
    elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,t
    elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=t,p,v
    elseif i==5 then r,g,b=v,p,q
    end
    return {r*255,g*255,b*255}
end


local function russian_dance_party()
    -- todo change delay
    f.set_delay(100)
    f:fade_color( hsv2rgb(math.random(),1,1) )
end

local function change_wave_single()
    rgb=hsv2rgb(hue,1,c.state.brightness / 100 )
    f:fade_color( rgb )
    hue = (hue + hue_step) %1
end

local function get_hue()
  return hue
end

return {wave=change_wave_single,
        single=change_wave_single,
        russian_dance_party=russian_dance_party,
        get_hue=get_hue}
