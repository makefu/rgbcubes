# API


# Modes:

## 

## fade
fade starting from start-color

- fade speed

## single
static led color

- start rgb color for each led

## wave

## russian dance party (nadia)
blink in different colors

## Knight Rider



# set LEDs

    POST /set

    <rgb * NumLEDs>

# Fade LEDs

post data is an array of rgb 3-byte array times the number of leds you want to fade


    POST /fade

    <rgb * NumLEDs>


# Preset LED Color

Presets (when restarting the uC) to the given colors

    POST /preset?type=(fade|single)

    (config:<rgb * NumLEDs>)

# Turn LED off

    GET /off

# Turn LED on


    GET /on


# Set Mode

  GET /mode?type=(fade|single)
