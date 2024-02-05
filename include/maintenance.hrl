-ifndef(MAINTENANCE_HRL).
-define(MAINTENANCE_HRL, "maintenance_hrl").

-include_lib("up/include/account.hrl").
-include_lib("up/include/component.hrl").
-include_lib("up/include/incident.hrl").

-record(maintenance, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        account = [] :: [] | #account{},
        component = [] :: [] | #component{},
        incident = [] :: [] | #incident{},
        state = open,
        date = {2015,1,1},
        terminationDate = {2015,1,1}
       }).

-endif.
