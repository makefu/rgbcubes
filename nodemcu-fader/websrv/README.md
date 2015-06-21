# API

see API.md

# uploading and dependencies

with esplorer, upload the following files and run `node.compile(<file>)`:

```
  - init.lua
  \-> wifi.lua                  # contains wifi settings
    \-> config.lua              # handles configuration settings
  \-> fadesrv.lua               # sets up the http server and handles requests
    \-> config
    \-> run_state.lua         # performs the action as received from request
      \-> config
      \-> fade.lua            # used to 'fade' colors
```

node.compile is essential because otherwise the esp will run OOM all the time
as you can see, this became quite complex

there are some auxilary files:

  - wheel.lua       # a color wheel action (like the one on the windo seat
  - knightrider.lua # knight rider animation

# License

of the lua code:

MIT
