SELECT 
    rxtime_utc,
    comm_mode,
    frequnecy,
    sender_callsign,
    receiver_callsign,
    snr
FROM {{ ref ('stg_psk') }}