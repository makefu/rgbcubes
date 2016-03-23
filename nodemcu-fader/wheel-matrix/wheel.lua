

local numLED = 12


local hue = 0 -- the current hue value, gets changed by functions
local brightness = 1
local hue_step= 0.002

local ledpin=4
local cols=2
local rows=3
local fader = require('fade')
fader.set_ledpin(ledpin)

local function russian_dance_party()
    local buf =""
    
    for i=1,numLED,1 do
        r,g,b=ws2812.hsv2rgb(math.random(),1,1)
        buf = buf.. string.char(g,r,b)
    end
    -- the real party mode!
    --ws2812.writergb(ledpin,buf)
    --fader.set_led(ledpin)
    fader.fade(buf,100,50)
      
end

local function inv(buf)
    -- inverts the rgb buffer to get a reversed column
    local nbuf=""
    
    for i=1,#buf,3 do
        nbuf =  buf:sub(i,i+2) .. nbuf
    end
    return nbuf
end

local blink_on = true

local function blink_white()
    if blink_on then
        ws2812.write(ledpin,string.char(0):rep(3):rep(numLED))
    else 
        ws2812.write(ledpin,string.char(255):rep(3):rep(numLED))
    end
    blink_on = not blink_on
end

local function change_wave_single()
    r,g,b=ws2812.hsv2rgb(hue,1,1)
    buf = string.char(g,r,b):rep(numLED)
    hue = (hue +  hue_step) %1
    ws2812.write(ledpin,buf)
    buf = nil
end
local function change_wave(color_space,angle)
    -- angle: the angle to the left
    if not angle then angle = 0 end
    if not color_space then color_space = 1 end
    
    -- a single step for a wave for the leds
    local buf="" -- the final buffer
    -- it only makes sense to use the color space between 0 and 1
    local led_step = color_space/cols
    local angle_hue = hue
    
    for current_row=1,rows,1 do
        col_buf = ""
        
        for j=1,cols,1 do
            local hv=(angle_hue+(j*led_step))%1
            r,g,b=ws2812.hsv2rgb(hv,1,1)
            col_buf = col_buf.. string.char(g,r,b)
        end
        
        if ( current_row % 2 ) == 0 then
            col_buf = inv(col_buf)
        end
        
        angle_hue = (angle_hue + angle) %1
        buf = buf .. col_buf
    end

    
    hue = (hue +  hue_step) %1
    ws2812.write(ledpin,buf)
    buf=nil
    tmr.wdclr()
end

local function change_wheel()
  local buf = ""
  local led_step = 1/numLED 
  -- 1/numLED  : the whole color wheel with the LEDs we have
  -- 2/numLED : the half of the color wheel
  for i=1,numLED,1 do
    -- 1 => max hue value
    local hv=(hue+(i*led_step))%1
    r,g,b=ws2812.hsv2rgb(hv,1,1)
    -- print(i,hv,r,g,b)
    buf = buf .. string.char(g,r,b)
  end
  hue = (hue +  hue_step) %1
  -- print(hue)
  ws2812.write(ledpin,buf)
  buf=nil
  tmr.wdclr()
end

local function get_hue()
  return hue
end

return {wheel=change_wheel,
        wave=change_wave,
        single=change_wave_single,
        blink_white=blink_white,
        russian_dance_party=russian_dance_party,
        get_hue=get_hue}
