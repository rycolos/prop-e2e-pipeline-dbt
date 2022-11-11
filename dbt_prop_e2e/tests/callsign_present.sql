-- returns no rows if callsign is present in ref('stg_psk') (sender_callsign OR receiver_callsign) 
-- or ref('stg_logbook') (home_station_callsign or receiver_callsign)

with logbook as (
	select 
        home_station_callsign, 
        receiver_callsign 
    from {{ ref('stg_logbook') }}
),

psk as (
	select 
        sender_callsign, 
        receiver_callsign 
    from {{ ref('stg_psk') }}
)

select 
    callsign 
from {{ ref('dim_station') }} as station

right join logbook on station.callsign = logbook.home_station_callsign and station.callsign = logbook.receiver_callsign
right join psk on station.callsign = psk.sender_callsign and station.callsign = psk.receiver_callsign
where callsign is not null