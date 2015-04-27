# API

## single
static led color, start rgb color for each led
  
  GET /all?r=255&g=0&b=128

## 

# Turn LED off

    GET /off

# Turn LED on

    GET /on

# Brightness

Sets the brightness of the led strip

    GET /brightness?val=128

# ------------- not implemented ---------------------

- persistence and all the things below

# Set Mode

  GET /mode?type=(fade|single)

## wave

  - wheel.lua

## russian dance party (nadia)
blink in different colors


## Knight Rider
  - knightrider.lua

# Preset LED Color

Presets (when restarting the uC) to the given colors

    POST /preset?type=(fade|single)

    (config:<rgb * NumLEDs>)

# Fade LEDs

post data is an array of rgb 3-byte array times the number of leds you want to fade


    POST /fade

    <rgb * NumLEDs>

# set LEDs

seems to have some problems with 'large' packets which are getting splitted

    POST /set

    <rgb * NumLEDs>

## fade
fade starting from start-color

- fade speed
