
--CAST(SQRT(POW(69.1 * ({{ station1_lat }}::REAL -  {{ station2_lat }}::REAL), 2) + POW(69.1 * ({{ station2_lon }}::REAL - {{ station1_lon }}::REAL) * COS({{ station1_lat }}::REAL / 57.3), 2)) AS REAL)

WITH station1 AS (
    SELECT
        callsign AS s1_call,
        psk_lat AS s1_lat,
        psk_lon AS s1_lon
    WHERE callsign = 'KC1QBY'
    FROM {{ ref('dim_station') }}
),

station2 AS (
    SELECT
        callsign AS s2_call,
        psk_lat AS s2_lat,
        psk_lon AS s2_lon
    WHERE callsign = 'NS4J'
    FROM {{ ref('dim_station') }}
),

SELECT s1_call, s1_lat, s2_lat FROM station1
UNION
SELECT s2_call, s2_lat, s2_lon FROM station2