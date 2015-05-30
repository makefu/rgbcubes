defaults = {
    brightness = 100,
    max_brightness= 100,
    fade_speed=1000,
    fade_steps=100,
    numled=16,
    pin=1,
    static={ default_color=string.char(0,200,0),
             off=string.char(0,0,0)
    },
    fade = {default_color=string.char(0,25,0)}
}

state = setmetatable({},{__index=defaults})

local fader = require('fade')
fader.set_ledpin(state.pin)

local function apply_brightness(color)
    -- todo: inline applying
    ncolor=""
    for i=1,#color do
        ncolor= ncolor.. string.char((color:byte(i,i)*state.brightness)/state.max_brightness)
    end
    return ncolor
end

local function change_state(nstate,data)
    --print(state.pin,state.numled,state.brightness)
    if nstate == "on" then
        fader.fade(apply_brightness(state.static.default_color):rep(state.numled),state.fade_speed,state.fade_steps)  

    elseif nstate == "off" then
        fader.fade(apply_brightness(state.static.off):rep(state.numled),state.fade_speed,state.fade_steps)  
        
    elseif nstate == "fade" then
        fader.fade(apply_brightness(data),state.fade_speed,state.fade_steps)

    elseif nstate == "brightness" then
        if not data then return "failed"  end
        
        state.brightness = data 
        if not state.data then
            state.data = state.static.default_color:rep(state.numled)
        end
        data = state.data
        print("new color"..state.data)
        print("new brightness"..state.brightness)
        --ws2812.writergb(state.pin,apply_brightness(state.data):rep(state.numled))
        fader.fade(apply_brightness(state.data),state.fade_speed,state.fade_steps)  
    elseif nstate == "static" then
        if not data then return "failed"  end
        fader.fade(apply_brightness(data),state.fade_speed,state.fade_steps)
        
    elseif nstate == "all" then
        if not data then return "failed"  end
        fader.fade(apply_brightness(data):rep(state.numled),state.fade_speed,state.fade_steps)
    else
        print("unknown state "..state.." with data "..data)
    end
    state.current=nstate
    state.data=data
end

local function get_state()
    return state,data
end
return {set_state=change_state,state=state,defaults=defaults}
