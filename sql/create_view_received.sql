CREATE VIEW received AS
    SELECT * FROM pskreporter_staged
	WHERE receivercallsign = 'KC1QBY';