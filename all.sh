# copy id key from from result of account.sh

export id=01707162568915302633
export key=01707162568915283933

curl -H "Auth: $key" -X PUT "http://localhost:5010/subscription/$id" -d @priv/subscription.json
curl -H "Auth: $key" -X GET "http://localhost:5010/subscription"
curl -H "Auth: $key" -X PUT "http://localhost:5010/component/$id" -d @priv/component.json
curl -H "Auth: $key" -X PUT "http://localhost:5010/component/$id" -d @priv/component.json
curl -H "Auth: $key" -X GET "http://localhost:5010/component"
curl -H "Auth: $key" -X PUT "http://localhost:5010/site/$id" -d @priv/site.json
curl -H "Auth: $key" -X PUT "http://localhost:5010/site/$id" -d @priv/site.json
curl -H "Auth: $key" -X GET "http://localhost:5010/site"
curl -H "Auth: $key" -X PUT "http://localhost:5010/incident/$id" -d @priv/incident.json
curl -H "Auth: $key" -X PUT "http://localhost:5010/incident/$id" -d @priv/incident.json
curl -H "Auth: $key" -X GET "http://localhost:5010/incident"
curl -H "Auth: $key" -X PUT "http://localhost:5010/maintenance/$id" -d @priv/maintenance.json
curl -H "Auth: $key" -X PUT "http://localhost:5010/maintenance/$id" -d @priv/maintenance.json
curl -H "Auth: $key" -X GET "http://localhost:5010/maintenance"
