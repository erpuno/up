# Webhook Integration for Status Monitoring

## Overview

This repository provides a webhook integration for receiving updates related to incidents, maintenances, and component status changes. The integration supports different events associated with a status page.

# UP: Incidents and Maintenance

[![Hex pm](http://img.shields.io/hexpm/v/up.svg?style=flat&x=1)](https://hex.pm/packages/up)

Minimalistic uptime server in Elixir with HTTP API and WebSocket SPA status page. See <a href="https://up.erp.uno">up.erp.uno</a>.

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




