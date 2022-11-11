with psk as (
	select * from {{ ref ('stg_psk') }}
),

logbook as (
	select * from {{ ref ('stg_logbook') }}
),

gridsquare_lon_lat as (
	select * from {{ ref ('gridsquare_lon_lat') }}
),

psk_pre_merge as (
	select 
		distinct sender_callsign as callsign,
		sender_locator as psk_locator,
		sender_dxcc as psk_country,
		null as antenna
	from psk

	union

	select 
		distinct receiver_callsign, 
		receiver_locator,
		null as dxcc,
		receiver_antenna_info as antenna
	from psk
	order by callsign asc
),

psk_merge as (
	select 
		distinct callsign,
		psk_locator,
		max(psk_country) as psk_country,
		max(antenna) as antenna_info
	from psk_pre_merge
	group by callsign, psk_locator
),

logbook_merge as (
	select 
		distinct home_station_callsign as callsign,
		home_station_locator as logb_locator,
		home_station_country as logb_country	
	from logbook
	union
	
	select 
		distinct receiver_callsign,
		receiver_locator,
		receiver_country	
	from logbook
),

final_merge as (
    select
        p.callsign,
        p.psk_locator,
        l.logb_locator,
        p.psk_country,
        l.logb_country,
        antenna_info
    from psk_merge as p
    full outer join logbook_merge as l
    on p.callsign = l.callsign
    order by l.logb_locator
),

final as ( 
    select 
        {{ dbt_utils.surrogate_key(['callsign', 'psk_locator']) }} as id,
		callsign,
        psk_locator,
        logb_locator,
        psk_country,
        logb_country,
        cast(g.lon_lat as point) as psk_lon_lat
    from final_merge as s
    join gridsquare_lon_lat as g
    on left(s.psk_locator, 4) = g.grid
)

select * from final