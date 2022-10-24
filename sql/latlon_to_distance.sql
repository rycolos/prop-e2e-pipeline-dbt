UPDATE pskreporter_staged
SET distance_mi = CAST(SQRT(POW(69.1 * (sender_lat -  receiver_lat), 2) + POW(69.1 * (receiver_lon - sender_lon) * COS(sender_lat / 57.3), 2)) AS REAL)
WHERE distance_mi IS NULL;
