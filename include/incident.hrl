-ifndef(INCIDENT_HRL).
-define(INCIDENT_HRL, "incident_hrl").

-include_lib("up/include/account.hrl").
-include_lib("up/include/component.hrl").

-record(incident, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        account = [] :: [] | #account{},
        component = [] :: [] | #component{},
        state = open,
        date = {2015,1,1},
        terminationDate = {2015,1,1}
       }).

-endif.
