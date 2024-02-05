-ifndef(SITE_HRL).
-define(SITE_HRL, "site_hrl").

-include_lib("up/include/account.hrl").
-include_lib("up/include/component.hrl").
-include_lib("up/include/incident.hrl").
-include_lib("up/include/maintenance.hrl").

-record(site, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        account = [] :: [] | #account{},
        components = [] :: list(#component{}),
        incidents = [] :: list(#incident{}),
        maintenance = [] :: list(#maintenance{}),
        state = open,
        date = [],
        terminationDate = []
       }).

-endif.
