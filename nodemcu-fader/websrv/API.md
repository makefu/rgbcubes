# API

## single
static led color, start rgb color for each led
  
  GET /single?r=255&g=0&b=128


# Turn LED off

    GET /off

# Turn LED on
single color mode with a pre-defined color

    GET /on
    

# Brightness

Sets the brightness of the led strip

    GET /brightness?val=128




# ------------- not implemented ---------------------

# status

Returns the current brightness, mode and color

    GET /status
    
    { <content of current config> }

- persistence and all the things below:

# persist settings

  GET /persist?mode=off|single|wheel

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

# set LEDs

set all the leds
seems to have some problems with 'large' packets which are getting splitted, we
are using the GET

    GET /set?data=%URL_ENCODED

#
