-ifndef(ACCOUNT_HRL).
-define(ACCOUNT_HRL, "site_hrl").

-include_lib("up/include/site.hrl").

-record(account, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        sites = [] :: [] | list(#site{}),
        key = [],
        state = open,
        date = {2015,1,1},
        terminationDate = {2015,1,1}
       }).

-endif.
