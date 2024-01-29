# UP: Incidents and Maintenance

[![Hex pm](http://img.shields.io/hexpm/v/up.svg?style=flat&x=1)](https://hex.pm/packages/up)

Minimalistic uptime server in Elixir with HTTP API and WebSocket SPA status page.

![image](https://github.com/erpuno/up/assets/144776/50a090c7-4ff0-4b9f-8a40-de32f750f06f)

```elixir
  get "/"
  get "/incidents"
  get "/incidents/:id"
  put "/incidents"
  get "/maintenance"
  get "/maintenance/:id"
  put "/maintenance"
  get "/metrics"
  get "/metrics/:id"
  put "/metrics"
  get "/components"
  get "/components/:type/:id"
  put "/components"
  get "/groups"
  get "/groups/:type/:id"
  put "/groups"
  get "/users"
  get "/users/:type/:id"
  put "/users"
```

## Features

* Incidents reporting
* Maintenance reporting
* Components/Groups taxonomy management

### Setup

```elixir
$ mix deps.get
$ iex -S mix
UP UPTIME/STATUS version 1.0.
1: HTTP API listening at port: 5010.
2: WebSocket NITRO listening at port: 5011.
Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 
```

## Credits

* Namdak Tonpa
