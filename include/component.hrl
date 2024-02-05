-ifndef(COMPONENT_HRL).
-define(COMPONENT_HRL, "component_hrl").

-include_lib("up/include/account.hrl").
-include_lib("up/include/site.hrl").

-record(component, {
        id = kvs:seq([],[]), next = [], prev = [],
        name = [],
        account = [] :: [] | #account{},
        site = [] :: [] | #site{},
        parent = [] :: [] | list()
       }).

-endif.
