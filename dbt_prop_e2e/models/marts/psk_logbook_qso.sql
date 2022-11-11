with psk_contact as (
	select * from {{ ref ('fact_psk_contact') }}
),

logbook_contact as (
	select * from {{ ref ('fact_logbook_contact') }}
),

final as (
	select
		p.rxtime_utc as psk_rxtime_utc,
		l.rxtime_utc as log_rxtime_utc,
		p.comm_mode as comm_mode,
		p.frequency as psk_frequency,
		l.frequency as log_frequency,
		p.sender_callsign as sender_callsign,
		p.receiver_callsign as receiver_callsign,
		p.snr as psk_snr,
		l.rst_sent as log_snr_sent,
		l.rst_rcvd as log_snr_rcvd
	from psk_contact p
	join logbook_contact l 
	on p.receiver_callsign = l.receiver_callsign
)

select * from final