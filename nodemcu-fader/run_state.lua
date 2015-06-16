defaults = {
    brightness = 100,
    max_brightness= 100,
    fade_speed=1000,
    fade_steps=100,
    numled=16,
    pin=1,
    mode="off",
    static={ default_color=string.char(0,200,0),
             off=string.char(0,0,0)
    }
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

local function run_state(nstate,data)
    --print(state.pin,state.numled,state.brightness)
    if nstate == "on" then
        run_state("single",state.static.default_color:rep(state.numled))

    elseif nstate == "off" then
        state.mode=nstate
        fader.fade(apply_brightness(state.static.off):rep(state.numled),state.fade_speed,state.fade_steps)  
        
    elseif nstate == "brightness" then
        if not data then return "failed"  end
        
        state.brightness = data 
        if not state.data then
            state.data = state.static.default_color:rep(state.numled)
        end
        data = state.data
        
        fader.fade(apply_brightness(state.data),state.fade_speed,state.fade_steps)  
        
    elseif nstate == "single" then
        if not data then return "failed"  end
        state.mode=nstate
        fader.fade(apply_brightness(data):rep(state.numled),state.fade_speed,state.fade_steps)
    else
        print("unknown state "..state.." with data "..data)
    end
    state.data=data
end

return {run_state=run_state,state=state,defaults=defaults}
