SELECT * FROM {{ ref ('stg_psk') }}
WHERE sender_callsign = 'KC1QBY'