{% macro station_distance(station1, station2) -%}

{% set s1_lat_query %}
select psk_lat from {{ ref('dim_station') }}
where callsign = '{{ station1 }}'
{% endset %}

{% set s1_lon_query %}
select psk_lon from {{ ref('dim_station') }}
where callsign = '{{ station1 }}'
{% endset %}

{% set s2_lat_query %}
select psk_lat from {{ ref('dim_station') }}
where callsign = '{{ station2 }}'
{% endset %}

{% set s2_lon_query %}
select psk_lon from {{ ref('dim_station') }}
where callsign = '{{ station2 }}'
{% endset %}

{% set station1_latq = run_query(s1_lat_query) %}
{% set station1_lonq = run_query(s1_lon_query) %}
{% set station2_latq = run_query(s2_lat_query) %}
{% set station2_lonq = run_query(s2_lon_query) %}

{% set station1_lat = station1_latq.columns[0].values() %}
{% set station1_lon = station1_lonq.columns[0].values() %}
{% set station2_lat = station2_latq.columns[0].values() %}
{% set station2_lon = station2_lonq.columns[0].values() %}

CAST(SQRT(POW(69.1 * ({{ station1_lat }}::REAL -  {{ station2_lat }}::REAL), 2) + POW(69.1 * ({{ station2_lon }}::REAL - {{ station1_lon }}::REAL) * COS({{ station1_lat }}::REAL / 57.3), 2)) AS REAL)

{%- endmacro %}