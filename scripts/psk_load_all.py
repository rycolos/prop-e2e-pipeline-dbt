import os, psycopg2, re, sys, yaml

data_dir = '/home/kepler/prop-e2e-pipeline/postgres_data/source_data'
docker_data_dir = '/var/lib/postgresql/data/source_data'

script_dir = os.path.dirname(__file__)
config_path = f'{script_dir}/config.yaml'

table_name = 'raw.psk'

def config_parse(config_path):
    #Parse yaml config file for db, user, pw, host, port
    try:
        with open(config_path, 'r') as file:
            config_file = yaml.safe_load(file)
    except FileNotFoundError as e:
        print(f'File {config_path} not found. Exiting.')
        sys.exit(1)
    try:
        db = config_file['database_info']['database']
        user = config_file['database_info']['username']
        pw = config_file['database_info']['password']
        host = config_file['database_info']['host']
        port = config_file['database_info']['port']
    except KeyError as e:
        print(f'Config missing key: {e}. Exiting.')
        sys.exit(1)
    return db, user, pw, host, port

def list_psk_csv(data_dir):
    #get list of csv files in dir
    pruned_f = []
    unpruned_f = os.listdir(data_dir)

    #remove from list if not ending in psk.csv
    for index, item in enumerate(unpruned_f):
        if re.match('^.*psk\.csv$', item):
            pruned_f.append(item)

    return pruned_f

def copy_all(db, host, user, pw, port, docker_data_dir, pruned_f):
    #connect to db and execute query, takes in pruned_f and db info
    conn = psycopg2.connect(database=db, host=host, user=user, password=pw, port=port)
    cur = conn.cursor()

    for item in pruned_f:
        query = f'''
        CREATE TEMP TABLE tmp_table ON COMMIT DROP AS SELECT sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode FROM {table_name}; \
        COPY tmp_table \
        FROM '{docker_data_dir}/{item}' \
        WITH (FORMAT CSV, HEADER, DELIMITER ','); \
        INSERT INTO {table_name} (sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode) \
        SELECT sNR, mode, mhz, rxTime, senderdxcc, flowstartseconds, senderCallsign, senderLocator, receiverCallsign, receiverLocator, receiverAntennaInformation, senderDXCCADIF, submode FROM tmp_table \
        ON CONFLICT DO NOTHING;
        '''

        cur.execute(query)
        conn.commit()

    cur.close()
    conn.close()

def main():
    db, user, pw, host, port = config_parse(config_path)

    pruned_f = list_psk_csv(data_dir)

    print(f'Uploading...\n{pruned_f}')

    copy_all(db, host, user, pw, port, docker_data_dir, pruned_f)

if __name__ == '__main__':
    main()