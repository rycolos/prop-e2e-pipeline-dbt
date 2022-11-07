
SELECT
    {{ station_distance(KC1QBY, NS4J) }} as distance_mi
FROM {{ ref('psk_logbook_qso') }}