-- WITH station1 AS (
--     SELECT
--         callsign AS s1_call,
--         psk_lat AS s1_lat,
--         psk_lon AS s1_lon
--     FROM {{ ref('dim_station') }}
--     WHERE callsign = 'KC1QBY'
-- ),

-- station2 AS (
--     SELECT
--         callsign AS s2_call,
--         psk_lat AS s2_lat,
--         psk_lon AS s2_lon
--     FROM {{ ref('dim_station') }}
--     WHERE callsign = 'NS4J'
-- )

-- SELECT
-- 	s1.s1_call,
-- 	s2.s2_call,
-- 	CAST(SQRT(POW(69.1 * (s1.s1_lat -  s2.s2_lat), 2) + POW(69.1 * (s2.s2_lon - s1.s1_lon) * COS(s1.s1_lat / 57.3), 2)) AS REAL) as distance_mi
-- FROM station1 s1 
-- CROSS JOIN station2 s2

SELECT 
    {{ station_distance('sender_callsign', 'receiver_callsign') }}
FROM {{ ref('psk_logbook_qso') }}
