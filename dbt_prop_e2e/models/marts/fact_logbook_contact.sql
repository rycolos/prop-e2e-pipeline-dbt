with source as (
   select * from {{ ref ('stg_logbook') }}
),

final as (
    select 
        id,
        rxtime_utc,
        comm_mode,
        frequency,
        home_station_callsign,
        receiver_callsign,
        rst_sent,
        rst_rcvd
    from source
)

select * from final