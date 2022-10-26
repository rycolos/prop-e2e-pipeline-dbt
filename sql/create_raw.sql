CREATE TABLE IF NOT EXISTS raw_psk (
    sNR TEXT,
    mode TEXT,
    MHz TEXT,
    rxTime TEXT NOT NULL,
    senderDXCC TEXT,
    flowStartSeconds TEXT,
    senderCallsign TEXT NOT NULL,
    senderLocator TEXT,
    receiverCallsign TEXT NOT NULL,
    receiverLocator TEXT,
    receiverAntennaInformation TEXT,
    senderDXCCADIF TEXT,
    submode TEXT,
    insertion_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT raw_psk_prim_key PRIMARY KEY (rxTime, senderCallsign, receiverCallsign),
    CONSTRAINT raw_check_kc1qby CHECK (receiverCallsign LIKE '%KC1QBY%' OR senderCallsign LIKE '%KC1QBY%')
);

CREATE TABLE IF NOT EXISTS raw_logbook (
    app_qrzlog_logid TEXT,
    call TEXT,
    country TEXT,
    frequency TEXT,
    gridsquare TEXT,
    mode TEXT,
    my_country TEXT,
    my_gridsquare TEXT,
    qrzcom_qso_upload_date TEXT,
    qso_date TEXT,
    rst_rcvd TEXT,
    rst_sent TEXT,
    station_callsign TEXT,
    time_off TEXT,
    tx_pwr TEXT,
    insertion_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT raw_log_prim_key PRIMARY KEY (app_qrzlog_logid)
);

