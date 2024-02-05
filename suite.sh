curl -H "Auth: secret" -X PUT "http://localhost:5010/account" -d @priv/account.json ; echo
curl -H "Auth: secret" -X PUT "http://localhost:5010/account" -d @priv/account.json ; echo
curl -H "Auth: secret" -X PUT "http://localhost:5010/account" -d @priv/account.json ; echo
curl -H "Auth: secret" -X GET "http://localhost:5010/account"
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/subscription/01707135870515049000" -d @priv/subscription.json ; echo
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/subscription/01707135870515049000" -d @priv/subscription.json ; echo
curl -H "Auth: 01707135870515017000" -X GET "http://localhost:5010/subscription"
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/site/01707135870515049000" -d @priv/site.json ; echo
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/site/01707135870515049000" -d @priv/site.json ; echo
curl -H "Auth: 01707135870515017000" -X GET "http://localhost:5010/site"
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/incident/01707135870515049000" -d @priv/incident.json ; echo
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/incident/01707135870515049000" -d @priv/incident.json ; echo
curl -H "Auth: 01707135870515017000" -X GET "http://localhost:5010/incident"
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/maintenance/01707135870515049000" -d @priv/maintenance.json ; echo
curl -H "Auth: 01707135870515017000" -X PUT "http://localhost:5010/maintenance/01707135870515049000" -d @priv/maintenance.json ; echo
curl -H "Auth: 01707135870515017000" -X GET "http://localhost:5010/maintenance"
