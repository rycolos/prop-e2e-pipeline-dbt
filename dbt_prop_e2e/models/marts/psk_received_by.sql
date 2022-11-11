with source as (
   select * from {{ ref ('stg_psk') }}
),

final as (
    select * from source
    where sender_callsign = 'KC1QBY'
)

select * from final
