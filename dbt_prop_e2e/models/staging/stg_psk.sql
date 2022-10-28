 with source as (
    select * from {{ source('raw', 'psk') }}
 ),

 transformed as (
    select
        cast(sNR as int) as snr,
        mode as comm_mode,
        cast(MHz as DOUBLE PRECISION) as frequency,
        TO_TIMESTAMP(rxtime, 'YYYY-MM-DD HH24:MI:SS') AT TIME ZONE 'UTC' as rxtime_utc,
        senderCallsign as sender_callsign,
        senderLocator as sender_locator,
        senderDXCC as sender_dxcc,
        receiverCallsign as receiver_callsign,
        receiverLocator as receiver_locator,
        receiverAntennaInformation as receiver_antenna_info
    from source
 )

select * from transformed