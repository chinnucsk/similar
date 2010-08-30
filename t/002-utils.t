#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pz ./ebin

-include_lib("./include/similar_data.hrl").

main(_) ->
	etap:plan(unknown),

	etap_can:loaded_ok(similar_utils, "Module 'similar_utils' loaded."),
	etap_can:can_ok(similar_utils, create_sim_state, 0),
	etap_can:can_ok(similar_utils, trace_on, 1),
	etap_can:can_ok(similar_utils, trace_off, 1),
	etap_can:can_ok(similar_utils, kill_current, 1),
	etap_can:can_ok(similar_utils, reset, 1),
	etap_can:can_ok(similar_utils, log, 2),
	etap_can:can_ok(similar_utils, format_time, 1),

	State = similar_utils:create_sim_state(),
	etap:is(is_dict(State#sm_data.events), true, "Events should be a dict"),
	etap:is(State#sm_data.resources, [], "Resources should be empty"),
	etap:is(State#sm_data.actives, [], "Actives should be empty"),
	etap:is(State#sm_data.time, 0, "Time should be 0"),
	etap:is(State#sm_data.props, [], "Props should be empty"),
	etap:is(State#sm_data.trace, false, "Trace should be false"),
	
	TraceOnState = similar_utils:trace_on(State),
	etap:is(TraceOnState#sm_data.trace, true, "Trace should be true"),
	
	TraceOffState = similar_utils:trace_off(TraceOnState),
	etap:is(TraceOffState#sm_data.trace, false, "Trace should be false"),

	etap:end_tests(),
	ok.

is_dict(D) ->
	case catch dict:to_list(D) of
		L when is_list(L) ->
			true;
		{'EXIT', {badarg,_}} ->
			false
	end.

