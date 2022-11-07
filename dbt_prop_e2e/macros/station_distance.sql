-- UPDATE pskreporter_staged
-- SET distance_mi = CAST(SQRT(POW(69.1 * (sender_lat -  receiver_lat), 2) + POW(69.1 * (receiver_lon - sender_lon) * COS(sender_lat / 57.3), 2)) AS REAL)
-- WHERE distance_mi IS NULL;

--lat lon from psk_lat and psk_lon in dim_station

{% macro station_distance(station1, station2) %}

{% set station1_lat = run_query('select psk_lat from {{ ref ('dim_station') where callsign = {{ station1 }} }}') %}
{% set station1_lon = run_query('select psk_lon from {{ ref ('dim_station') where callsign = {{ station1 }} }}') %}
{% set station2_lat = run_query('select psk_lat from {{ ref ('dim_station') where callsign = {{ station2 }} }}') %}
{% set station2_lon = run_query('select psk_lon from {{ ref ('dim_station') where callsign = {{ station2 }} }}') %}

CAST(SQRT(POW(69.1 * ({{ station1_lat }} -  {{ station2_lat }}), 2) + POW(69.1 * ({{ station2_lon }} - {{ station1_lon }}) * COS({{ station1_lat }} / 57.3), 2)) AS REAL)

{% endmacro %}