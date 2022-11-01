SELECT 
    rxtime_utc,
    comm_mode,
    frequency,
    sender_callsign,
    receiver_callsign,
    snr
FROM {{ ref ('stg_psk') }}