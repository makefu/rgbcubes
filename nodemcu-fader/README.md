# API

see API.md

# uploading and dependencies

with esplorer, upload the following files and run `node.compile(<file>)`:

```
  - init.lua
  \-> wifi.lua                  # contains wifi settings
  \-> fadesrv.lua               # sets up the http server
    \-> handle_request.lua      # handles an http request
      \-> run_state.lua         # performs the action as received from request
                                # also contains defaults
        \-> fade.lua            # used to 'fade' colors
          \-> loop.lua          # performs 'timed loop'
```

node.compile is essential because otherwise the esp will run OOM all the time
as you can see, this became quite complex

there are some auxilary files:

  - wheel.lua       # a color wheel action (like the one on the windo seat
  - knightrider.lua # knight rider animation

# License

of the lua code:

MIT
