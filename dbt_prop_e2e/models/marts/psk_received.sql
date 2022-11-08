SELECT * FROM {{ ref ('stg_psk') }}
WHERE receiver_callsign = 'KC1QBY'