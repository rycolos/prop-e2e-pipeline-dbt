 with source as (
    select * from {{ source('analysis_raw', 'logbook') }}
 ),

pre_transform AS (
	select
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
	from source
),

transformed as (
  select
    to_timestamp(cast(extract(epoch from(cast(qso_date as date) + make_time(cast(substring(time_off, 1, 2) as int), cast(substring(time_off, 3, 2) as int), 00))) as double precision)) as rxtime_utc,
    comm_mode,
    frequency,
    home_station_callsign,
    home_station_locator,
    home_station_country,
    receiver_callsign,
    receiver_locator,
    receiver_country,
    rst_rcvd,
    rst_sent,
    tx_pwr,
    cast(app_qrzlog_logid as bigint),
    cast(qrzcom_qso_upload_date as date)
  from pre_transform
),

final as (
  select
    {{ dbt_utils.surrogate_key(['rxtime_utc', 'home_station_callsign', 'receiver_callsign']) }} as id,
    rxtime_utc,
    comm_mode,
    frequency,
    home_station_callsign,
    home_station_locator,
    home_station_country,
    receiver_callsign,
    receiver_locator,
    receiver_country,
    rst_rcvd,
    rst_sent,
    tx_pwr,
    app_qrzlog_logid,
    qrzcom_qso_upload_date
  from transformed
)

select * from final