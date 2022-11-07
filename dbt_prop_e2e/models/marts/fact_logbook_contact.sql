SELECT 
    rxtime_utc,
    comm_mode,
    frequency,
    home_station_callsign,
    receiver_callsign,
    rst_sent,
    rst_rcvd,
    {{ station_distance('home_station_callsign', 'receiver_callsign') }} as distance_mi
FROM {{ ref ('stg_logbook') }}