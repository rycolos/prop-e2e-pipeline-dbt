 with source as (
    select * from {{ source('raw', 'logbook') }}
 ),

 transformed as (
    select
      cast(qso_date as date),
      time_off,
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


-- INSERT INTO logbook_staged (qso_date, time_off, frequency, comm_mode, receiver_callsign, receiver_locator, sender_callsign, sender_locator, rst_rcvd, rst_sent, tx_pwr, app_qrzlog_logid, qrzcom_qso_upload_date)
-- SELECT
--     CAST(qso_date AS DATE),
--     time_off,
--     CAST(frequency AS DOUBLE PRECISION),
--     mode,
--     call,
--     gridsquare,
--     station_callsign,
--     my_gridsquare,
--     CAST(rst_rcvd AS INTEGER),
--     CAST(rst_sent AS INTEGER),
--     CAST(tx_pwr AS INTEGER),
--     CAST(app_qrzlog_logid AS BIGINT),
--     CAST(qrzcom_qso_upload_date AS DATE)