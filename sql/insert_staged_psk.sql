INSERT INTO pskreporter_staged (snr, comm_mode, frequency, rxtime_utc, sender_callsign, sender_locator, receiver_callsign, receiver_locator)
SELECT
    CAST(sNR AS INT),
    mode,
    CAST(MHz AS DOUBLE PRECISION),
    TO_TIMESTAMP(rxtime, 'YYYY-MM-DD HH24:MI:SS') AT TIME ZONE 'UTC',
    senderCallsign,
    senderLocator,
    receiverCallsign,
    receiverLocator
FROM pskreporter_raw
ON CONFLICT DO NOTHING;