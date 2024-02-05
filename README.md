## UP: Incidents and Maintenance

[![Hex pm](http://img.shields.io/hexpm/v/up.svg?style=flat&x=1)](https://hex.pm/packages/up)

Minimalistic uptime server in Elixir with HTTP API and WebSocket SPA status page with proxy to Instatus.
See <a href="https://up.erp.uno">up.erp.uno</a>. UP supports mupltiple Accounts, multiple Sites per account,
multiple Components per Site, multiple Incidents per Components, multiple Maintenances per Incident,
multiple Subscription callback per Account.

Similar produts: Sematext, Hyperping, Cronitor, Atlassian Statuspage,
Better Uptime, Instatus, Freshstatus, Statuspal, Cachet, Vigil, StatusCast, Statping.

```elixir
  get "/"
  get "/incidents"
  get "/incidents/:id"
  put "/incidents/:id"
  get "/sites"
  get "/sites/:id"
  put "/sites/:id"
  get "/maintenance"
  get "/maintenance/:id"
  put "/maintenance/:id"
  get "/metrics"
  get "/metrics/:id"
  put "/metrics/:id"
  get "/components"
  get "/components/:id"
  put "/components/:id"
  get "/subscriptions"
  get "/subscriptions/:id"
  put "/subscriptions/:id"
  get "/accounts"
  get "/accounts/:id"
  put "/accounts/"
```

## Features

* Incidents reporting
* Maintenance announcing
* Components management
* Callback URL Subscriptions
* Telemetry

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

### Statuses

The schema objects have the following life cycles:

 * For `Site`: `UP` | `HASISSUES` | `MAINTENANCE`.
 * For `Component`: `OPERATIONAL` | `MAINTENANCE` | `PERFORMANCE` | `OUTAGE` | `INACCESSIBLE`.
 * For `Incident`: `INVESTIGATING`, `IDENTIFIED`, `MONITORING`, `RESOLVED`.
 * For `Maintenance`: `NOTSTARTEDYET`, `INPROGRESS`, `COMPLETED`.

### Account Management

Accounts could only by created with security admin API key, which can
be set with `:application.set_env(:up, :security_admin, "secret")`.
Then you can add new accounts.

Create User:

```
$ curl -H "Auth: secret" -X PUT "http://localhost:5010/account" -d @priv/account.json
[
  {
    "id": "maxim-0012",
    "spec": "put",
    "type": "accounts"
  }
]
```

List Users:

```
$ curl -H "Auth: secret" -X GET "http://localhost:5010/account"
[
  {
    "result": [
      {
        "id": "maxim-0012",
        "key": "01707128300216989000",
        "name": "Maksym Sokhatskyi",
        "sites": []
      }
    ],
    "spec": "lst",
    "type": "accounts"
  }
]
```

### Site Management

```
$ curl -H "Auth: 01707128300216989000" -X GET "http://localhost:5010/site/maxim-0012"
[
  {
    "result": [],
    "spec": "get",
    "type": "sites"
  }
]
```

### Subscription Management

```
$ curl -H "Auth: 01707128300216989000" -X GET "http://localhost:5010/subscription/maxim-0012"
[
  {
    "result": [],
    "spec": "get",
    "type": "subscriptions"
  }
]
```

### Component Management

```
$ curl -H "Auth: 01707128300216989000" -X GET "http://localhost:5010/component/maxim-0012"
[
  {
    "result": [],
    "spec": "get",
    "type": "component"
  }
]
```

### Maintenance Management

```
$ curl -H "Auth: 01707135870515017000" -X GET "http://localhost:5010/maintenance"
[
  {
    "result": [
      {
        "account": "01707135870515049000",
        "id": "01707136783810045000",
        "incident": [],
        "name": "Maksym Sokhatskyi"
      },
      {
        "account": "01707135870515049000",
        "id": "01707136783833913000",
        "incident": [],
        "name": "Maksym Sokhatskyi"
      }
    ],
    "spec": "lst",
    "type": "maintenance"
  }
]
```

