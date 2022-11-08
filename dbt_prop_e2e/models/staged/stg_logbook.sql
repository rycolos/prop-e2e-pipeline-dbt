 with source as (
    select * from {{ source('source', 'logbook') }}
 ),

pre_transform AS (
	SELECT
		cast(qso_date AS text),
		cast(time_off AS text),
	    mode as comm_mode,
      	cast(freq as double precision) as frequency,
      	station_callsign as home_station_callsign,
      	my_gridsquare as home_station_locator,
      	my_country as home_station_country,
      	call as receiver_callsign,
      	gridsquare as receiver_locator,
      	country as receiver_country,
      	rst_rcvd,
      	rst_sent,
      	tx_pwr,
      	cast(app_qrzlog_logid as bigint),
		cast(qrzcom_qso_upload_date as text)
	FROM source
),

transformed as (
    select
      {{ dbt_utils.surrogate_key(['rxtime', 'sendercallsign', 'receivercallsign']) }} as id,
      to_timestamp(cast(extract(epoch from(cast(qso_date as date) + make_time(cast(substring(time_off, 1, 2) as int), cast(substring(time_off, 3, 2) as int), 00))) as double precision)) as rxtime_utc,
      comm_mode,
      frequency,
      home_station_callsign,
      home_station_locator,
      home_station_country,
      receiver_callsign,
      receiver_locator,
      receiver_country,
      cast(rst_rcvd as int),
      cast(rst_sent as int),
      cast(tx_pwr as int),
      cast(app_qrzlog_logid as bigint),
      cast(qrzcom_qso_upload_date as date)
    from pre_transform
)

select * from transformed