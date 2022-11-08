 with source as (
    select * from {{ source('source', 'logbook') }}
 ),

 transformed as (
    select
      {{ dbt_utils.surrogate_key(['qso_date', 'time_off', 'call']) }} as id,
      to_timestamp(cast(extract(epoch from(cast(qso_date as date) + make_time(cast(substring(time_off, 1, 2) as int), cast(substring(time_off, 3, 2) as int), 00))) as double precision)) as rxtime_utc,
      mode as comm_mode,
      cast(frequency as double precision),
      station_callsign as home_station_callsign,
      my_gridsquare as home_station_locator,
      my_country as home_station_country,
      call as receiver_callsign,
      gridsquare as receiver_locator,
      country as receiver_country,
      cast(rst_rcvd as int),
      cast(rst_sent as int),
      cast(tx_pwr as int),
      cast(app_qrzlog_logid as bigint),
      cast(qrzcom_qso_upload_date as date)
    from source
 )

select * from transformed