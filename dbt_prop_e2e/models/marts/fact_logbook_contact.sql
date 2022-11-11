SELECT 
    id,
    rxtime_utc,
    comm_mode,
    frequency,
    home_station_callsign,
    receiver_callsign,
    rst_sent,
    rst_rcvd
FROM {{ ref ('stg_logbook') }}