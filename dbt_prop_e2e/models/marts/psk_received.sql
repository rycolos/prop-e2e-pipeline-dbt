with source as (
   select * from {{ ref ('stg_psk') }}
),

final as (
    select * from source
    where receiver_callsign = 'KC1QBY'
)

select * from final