SELECT
	p.rxtime_utc as psk_rxtime_utc,
	l.rxtime_utc as log_rxtime_utc,
	p.comm_mode,
	p.frequency as psk_frequency,
	l.frequency as log_frequency,
	p.sender_callsign,
	p.receiver_callsign,
	p.snr as psk_snr,
	l.rst_sent as log_snr_sent,
	l.rst_rcvd as log_snr_rcvd,
	{{ station_distance('p.sender_callsign', 'p.receiver_callsign') }} as distance_mi
FROM {{ ref ('fact_psk_contact') }} p
JOIN {{ ref ('fact_logbook_contact') }}l 
ON p.receiver_callsign = l.receiver_callsign