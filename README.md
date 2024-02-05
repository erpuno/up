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

### Accounts Management

Accounts could only by created with security admin API key, which can
be set with `:application.set_env(:up, :security_admin, "secret")`.
Then you can add new accounts.

Create User:

```
$ curl -H "Auth: secret" -X PUT "http://localhost:5010/accounts/" -d @priv/account.json -v
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
$ curl -H "Auth: secret" -X GET "http://localhost:5010/accounts/" ; echo
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

### Sites Managements

```
$ curl -H "Auth: 01707128300216989000" -X GET "http://localhost:5010/sites/maxim-0012" ; echo
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
$ curl -H "Auth: 01707128300216989000" -X GET "http://localhost:5010/subscriptions/maxim-0012" ; echo
[
  {
    "result": [],
    "spec": "get",
    "type": "subscriptions"
  }
]
```

## Webhook Formats

### Incident Updates

```json
{
  "meta": {
    "unsubscribe": "",
    "documentation": ""
  },
  "page": {
    "id": "",
    "status_indicator": "",
    "status_description": "",
    "url": ""
  },
  "incident": {
    "backfilled": false,
    "created_at": "",
    "impact": "",
    "name": "",
    "resolved_at": "",
    "status": "",
    "updated_at": "",
    "id": "",
    "url": "",
    "incident_updates": [{
      "id": "",
      "incident_id": "",
      "body": "",
      "status": "",
      "created_at": "",
      "updated_at": ""
    }]
  }
}
```
Maintenance Updates
```json
{
  "meta": {
    "unsubscribe": "",
    "documentation": ""
  },
  "page": {
    "id": "",
    "status_indicator": "",
    "status_description": "",
    "url": ""
  },
  "maintenance": {
    "backfilled": false,
    "created_at": "",
    "impact": "",
    "name": "",
    "resolved_at": "",
    "status": "",
    "updated_at": "",
    "id": "",
    "url": "",
    "duration": "",
    "maintenance_updates": [{
      "id": "",
      "maintenance_id": "",
      "body": "",
      "status": "",
      "created_at": "",
      "updated_at": ""
    }]
  }
}
```

Component Updates
```json

{
  "meta": {
    "unsubscribe": "",
    "documentation": ""
  },
  "page": {
    "id": "",
    "status_indicator": "",
    "status_description": "",
    "url": ""
  },
  "component_update": {
    "created_at": "",
    "new_status": "",
    "component_id": ""
  },
  "component": {
    "created_at": "",
    "id": "",
    "name": "",
    "status": ""
  }
}
```

### Status Page and Component Statuses
## Page Statuses:

```
UP
HASISSUES
UNDER MAINTENANCE
```

# Component Statuses:
```
OPERATIONAL
UNDERMAINTENANCE
DEGRADEDPERFORMANCE
PARTIALOUTAGE
MAJOROUTAGE
```
# Incident Statuses:
```
INVESTIGATING
IDENTIFIED
MONITORING
RESOLVED
```
# Maintenance Statuses:
```
NOTSTARTEDYET
INPROGRESS
COMPLETED
```
Usage
Subscribe to webhooks using the provided formats.
Receive updates for incidents, maintenances, and component status changes.
Use the provided status page and component statuses to monitor and act accordingly.




