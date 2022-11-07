SELECT 
    {{ station_distance('sender_callsign', 'receiver_callsign') }}
FROM {{ ref('psk_logbook_qso') }}
