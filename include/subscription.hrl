-ifndef(SUBSCRIPTION_HRL).
-define(SUBSCRIPTION_HRL, "subscription_hrl").

-include_lib("up/include/account.hrl").

-record(subscription, {
        id = kvs:seq([],[]), next = [], prev = [],
        account = [] :: [] | #account{},
        name = [],
        endpoint = [],
        state = open,
        date = {2015,1,1},
        terminationDate = {2015,1,1}
       }).

-endif.
