CREATE VIEW received_by AS
    SELECT * FROM pskreporter_staged
	WHERE sendercallsign = 'KC1QBY';