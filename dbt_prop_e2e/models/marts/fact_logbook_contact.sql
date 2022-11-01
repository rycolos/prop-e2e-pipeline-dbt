SELECT 
    rxtime_utc,
    comm_mode,
    frequnecy,
    sender_callsign,
    receiver_callsign,
    rst_sent,
    rst_recvd
FROM {{ ref ('stg_logbook') }}