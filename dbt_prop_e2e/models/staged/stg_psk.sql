with source as (
   select * from {{ source('analysis_raw', 'psk') }}
),

transformed as (
	select
		"sNR" as snr,
		mode,
		"MHz" as mhz,
		"rxTime" as rxtime,
		"senderDXCC" as senderdxcc,
		"flowStartSeconds" as flowstartseconds,
		"senderCallsign" as sendercallsign,
		"senderLocator" as senderlocator,
		"receiverCallsign" as receivercallsign,
		"receiverLocator" as receiverlocator,
		"receiverAntennaInformation" as receiverantennainformation,
		"senderDXCCADIF" as senderdxccadif,
		submode
	from source
),

final as (
	select
		{{ dbt_utils.surrogate_key(['rxtime', 'sendercallsign', 'receivercallsign']) }} as id,
		rxtime as rxtime_utc,
		mode as comm_mode,
		cast(MHz as DOUBLE PRECISION) as frequency,
		senderCallsign as sender_callsign,
		senderLocator as sender_locator,
		senderDXCC as sender_dxcc,
		receiverCallsign as receiver_callsign,
		receiverLocator as receiver_locator,
		receiverAntennaInformation as receiver_antenna_info,
		cast(sNR as int) as snr
	from transformed
)

select * from final
