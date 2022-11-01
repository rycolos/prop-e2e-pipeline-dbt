WITH psk_pre_merge AS (
	SELECT 
		DISTINCT sender_callsign AS callsign,
		sender_locator AS psk_locator,
		sender_dxcc AS psk_country,
		NULL AS antenna
	FROM {{ ref ('stg_psk') }}

	UNION

	SELECT 
		DISTINCT receiver_callsign, 
		receiver_locator,
		NULL AS dxcc,
		receiver_antenna_info AS antenna
	FROM {{ ref ('stg_psk') }}
	ORDER BY callsign ASC
),

psk_merge AS (
	SELECT 
		DISTINCT callsign,
		psk_locator,
		MAX(psk_country) AS psk_country,
		MAX(antenna) AS antenna_info
	FROM psk_pre_merge
	GROUP BY callsign, psk_locator
),

logbook_merge AS (
	SELECT 
		DISTINCT sender_callsign AS callsign,
		sender_locator AS logb_locator,
		sender_country AS logb_country	
	FROM {{ ref ('stg_logbook') }}

	UNION
	
	SELECT 
		DISTINCT receiver_callsign,
		receiver_locator,
		receiver_country	
	FROM {{ ref ('stg_logbook') }}
),

final AS (
    SELECT
        p.callsign,
        p.psk_locator,
        l.logb_locator,
        p.psk_country,
        l.logb_country,
        antenna_info
    FROM psk_merge AS p
    FULL OUTER JOIN logbook_merge AS l
    ON p.callsign = l.callsign
    ORDER BY l.logb_locator
)

SELECT * FROM final