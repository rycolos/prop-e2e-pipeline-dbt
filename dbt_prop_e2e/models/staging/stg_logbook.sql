 with source as (
    select * from {{ source('raw', 'logbook') }}
 ),

 transformed as (
    select
      -- cast(qso_date as date),
      -- time_off as time_off_utc
      to_timestamp(cast(extract(epoch from(cast(qso_date as date) + make_time(cast(substring(time_off, 1, 2) as int), cast(substring(time_off, 3, 2) as int), 00))) as double precision)) at time zone 'UTC' as rxtime_utc,
      cast(frequency as double precision),
      mode as comm_mode,
      station_callsign as sender_callsign,
      my_gridsquare as sender_locator,
      my_country as sender_country,
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