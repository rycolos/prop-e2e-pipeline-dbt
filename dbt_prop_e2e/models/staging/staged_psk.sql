 with source as (
    select * from {{ source('raw', 'psk') }}
 ),

 transformed as (
    select
        sNR,
        mode as comm_mode,
        frequency,
        rxtime as rxtime_utc,
        senderCallsign as sender_callsign,
        senderLocator as sender_locator,
        receiverCallsign as receiver_callsign,
        receiverLocator as receiver_locator
    from source
 )

select * from transformed

--     id  BIGINT GENERATED ALWAYS AS IDENTITY,
--     snr INT,
--     comm_mode TEXT,
--     frequency DOUBLE PRECISION,
--     rxtime_utc TIMESTAMPTZ,
--     sender_callsign TEXT,
--     sender_locator TEXT,
--     sender_lat REAL,
--     sender_lon REAL,
--     receiver_callsign TEXT,
--     receiver_locator TEXT,
--     receiver_lat REAL,
--     receiver_lon REAL,
--     distance_mi REAL,
--     insertion_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     CONSTRAINT staged_psk_prim_key PRIMARY KEY (rxtime_utc, sender_callsign, receiver_callsign),
--     CONSTRAINT staged_check_kc1qby CHECK (receiver_callsign LIKE '%KC1QBY%' OR sender_callsign LIKE '%KC1QBY%')


-- INSERT INTO pskreporter_staged (snr, comm_mode, frequency, rxtime_utc, sender_callsign, sender_locator, receiver_callsign, receiver_locator)
-- SELECT
--     CAST(sNR AS INT),
--     mode,
--     CAST(MHz AS DOUBLE PRECISION),
--     TO_TIMESTAMP(rxtime, 'YYYY-MM-DD HH24:MI:SS') AT TIME ZONE 'UTC',
--     senderCallsign,
--     senderLocator,
--     receiverCallsign,
--     receiverLocator