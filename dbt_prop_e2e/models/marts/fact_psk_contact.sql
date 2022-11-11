with source as (
   select * from {{ ref ('stg_psk') }}
),

final as (
    select 
        id,
        rxtime_utc,
        comm_mode,
        frequency,
        sender_callsign,
        receiver_callsign,
        snr
    from source
)

select * from final
