INSERT INTO logbook_staged (qso_date, time_off, frequency, comm_mode, receiver_callsign, receiver_locator, sender_callsign, sender_locator, rst_rcvd, rst_sent, tx_pwr, app_qrzlog_logid, qrzcom_qso_upload_date)
SELECT
    CAST(qso_date AS DATE),
    time_off,
    CAST(frequency AS DOUBLE PRECISION),
    mode,
    call,
    gridsquare,
    station_callsign,
    my_gridsquare,
    CAST(rst_rcvd AS INTEGER),
    CAST(rst_sent AS INTEGER),
    CAST(tx_pwr AS INTEGER),
    CAST(app_qrzlog_logid AS BIGINT),
    CAST(qrzcom_qso_upload_date AS DATE)
FROM logbook_raw
ON CONFLICT DO NOTHING;