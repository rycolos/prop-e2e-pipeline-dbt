with source as (
   select * from {{ source('source', 'psk') }}
),

transformed as (
   select
      {{ dbt_utils.surrogate_key(['rxtime', 'sendercallsign', 'receivercallsign']) }} as id,
      to_timestamp(rxtime, 'YYYY-MM-DD HH24:MI:SS') as rxtime_utc,
      mode as comm_mode,
      cast(MHz as DOUBLE PRECISION) as frequency,
      senderCallsign as sender_callsign,
      senderLocator as sender_locator,
      senderDXCC as sender_dxcc,
      receiverCallsign as receiver_callsign,
      receiverLocator as receiver_locator,
      receiverAntennaInformation as receiver_antenna_info,
      cast(sNR as int) as snr
    from source
 )

select * from transformed