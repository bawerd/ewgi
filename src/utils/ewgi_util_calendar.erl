%%%----------------------------------------------------------------------
%% @copyright Hunter Morris
%% @author Hunter Morris <huntermorris@gmail.com>
%% @version {@vsn}, {@date}, {@time}
%% @doc ewgi date/time helpers
%%
%% See LICENSE file in this source package
%%%----------------------------------------------------------------------

-module(ewgi_util_calendar).
-author('Hunter Morris <hunter.morris@smarkets.com>').

-define(UNIX_EPOCH, {{1970,1,1},{0,0,0}}).

-export([now_to_unix_ts/0, now_to_unix_ts/1, now_to_unix_ts/2, now_utc_ms/0, now_utc_ts_ms/0]).

%% @spec now_to_unix_ts() -> integer()
%% @doc Gives the current UNIX timestamp.
-spec now_to_unix_ts() -> non_neg_integer().
now_to_unix_ts() ->
    now_to_unix_ts(calendar:now_to_universal_time(erlang:now())).

%% @spec now_to_unix_ts(calendar:t_datetime1970()) -> integer()
%% @doc Gives the UNIX timestamp for the corresponding time value.
-spec now_to_unix_ts(calendar:t_datetime1970()) -> non_neg_integer().
now_to_unix_ts(Tm) ->
    calendar:datetime_to_gregorian_seconds(Tm) -
        calendar:datetime_to_gregorian_seconds(?UNIX_EPOCH).

%% @spec now_to_unix_ts(calendar:t_datetime1970(), non_neg_integer()) -> float()
%% @doc Gives the current UNIX timestamp with fractional microseconds.
-spec now_to_unix_ts(calendar:t_datetime1970(), non_neg_integer()) -> float().
now_to_unix_ts(Tm, 0) ->
    now_to_unix_ts(Tm);
now_to_unix_ts(Tm, Ms) when is_integer(Ms) ->
    now_to_unix_ts(Tm) + (Ms / 1000000).

%% @spec now_utc_ms() -> {calendar:t_datetime1970(), non_neg_integer()}
%% @doc Gives a tuple representing the current UNIX timestamp and microseconds.
-spec now_utc_ms() -> {calendar:t_datetime1970(), non_neg_integer()}.
now_utc_ms() ->
    {_, _, Ms} = Now = erlang:now(),
    {calendar:now_to_universal_time(Now), Ms}.

%% @spec now_utc_ts_ms() -> integer()
%% @doc Gives the number of milliseconds since the UNIX epoch.
-spec now_utc_ts_ms() -> integer().
now_utc_ts_ms() ->
    {Tm, Ms} = now_utc_ms(),
    now_to_unix_ts(Tm) * 1000 + round(Ms / 1000).
