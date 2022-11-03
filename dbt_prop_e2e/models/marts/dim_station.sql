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

final_merge AS (
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
),

transformed AS ( 
    SELECT 
        callsign,
        psk_locator,
        logb_locator,
        psk_country,
        logb_country,
        g.lat AS psk_lat,
        g.lon AS psk_lon
    FROM final_merge AS s
    JOIN {{ ref ('gridsquare_lat_lon') }} AS g
    ON LEFT(s.psk_locator, 4) = g.grid
)

SELECT * FROM transformed