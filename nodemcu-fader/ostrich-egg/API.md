# API

## single
static led color, start rgb color for each led
  
  GET /color?r=255&g=0&b=128
  
## brightness
// not yet implemented
  GET /brightness?brightness=50

  
# Turn LED off

    GET /off

# Turn LED on
single color mode with a pre-defined color

    GET /on
    
# Restart

    GET /restart

# Save
Save current configuration

    GET /save

# fadedelay
sets the time needed for a fade from one color to another. this config will be
persisted with `/save`

    GET /fadedelay?ms=<delay-in-milliseconds>



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
