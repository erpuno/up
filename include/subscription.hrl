-ifndef(SUBSCRIPTION_HRL).
-define(SUBSCRIPTION_HRL, "subscription_hrl").

-include_lib("up/include/account.hrl").

-record(subscription, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        account = [] :: [] | #account{},
        endpoint = [],
        state = open,
        date = [],
        terminationDate = []
       }).

-endif.
