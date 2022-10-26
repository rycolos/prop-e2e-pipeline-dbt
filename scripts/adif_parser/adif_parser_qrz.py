import os, pandas as pd, re, sys
from datetime import date

#modified from https://github.com/bjorgan/adif_parser
#designed to work only with QRZ.com exports
#currently, all columns must have a value to parse correctly

#pass in adif filename and path as argument
FILE = sys.argv[1]

script_dir = os.path.dirname(__file__)
date = date.today().strftime('%Y-%m-%d')
export_file = f'{script_dir}/{date}_logb.csv'

#define variable per adif column in log file
app_qrzlog_logid_col = 'app_qrzlog_logid'
app_qrzlog_qsldate_col = 'app_qrzlog_qsldate'
app_qrzlog_status_col = 'app_qrzlog_status'
band_col = 'band'
band_rx_col = 'band_rx'
call_col = 'call'
cnty_col = 'cnty'
comment_col = 'comment'
cont_col = 'cont'
country_col = 'country'
cqz_col = 'cqz'
distance_col = 'distance'
dxcc_col = 'dxcc'
email_col = 'email'
eqsl_qsl_rcvd_col = 'eqsl_qsl_rcvd'
eqsl_qsl_sent_col = 'eqsl_qsl_sent'
freq_col = 'freq'
freq_rx_col = ''
gridsquare_col = 'gridsquare'
ituz_col = 'ituz'
lat_col = 'lat'
lon_col = 'lon'
lotw_qsl_rcvd_col = 'lotw_qsl_rcvd'
lotw_qsl_sent_col = 'lotw_qsl_sent'
mode_col = 'mode'
my_city_col = 'my_city'
my_cnty_col = 'my_cnty'
my_country_col = 'my_country'
my_cq_zone_col = 'my_cq_zone'
my_gridsquare_col = 'my_gridsquare'
my_itu_zone_col = 'my_itu_zone'
my_lat_col = 'my_lat'
my_lon_col = 'my_lon'
my_name_col = 'my_name'
name_col = 'name'
qrzcom_qso_upload_date_col = 'qrzcom_qso_upload_date'
qrzcom_qso_upload_status_col = 'qrzcom_qso_upload_status'
qsl_rcvd_col = 'qsl_rcvd'
qsl_sent_col = 'qsl_sent'
qso_date_col = 'qso_date'
qso_date_off_col = 'qso_date_off'
qth_col = 'qth'
rst_rcvd_col = 'rst_rcvd'
rst_sent_col = 'rst_sent'
state_col = 'state'
station_callsign_col = 'station_callsign'
time_off_col = 'time_off'
time_on_col = 'time_on'
tx_pwr_col = 'tx_pwr'

def extract_adif_column(adif_file, col):
    #regex match and extract value from adif column
    pattern = re.compile(f'^.*<{col}:\d\d*>([^<]*)', re.IGNORECASE)

    matches = [re.match(pattern, line) for line in adif_file]
    matches = [line[1].strip() for line in matches if line is not None]
    adif_file.seek(0)

    return matches

def parse_adif(filename):
    #create dataframe from file where value is the result of extract_adif_colum() with a given column name
    #comment out unwanted rows
    #need a better way to handle rows that don't exist

    df = pd.DataFrame()
    adif_file = open(filename, 'r')

    try:
        df = pd.DataFrame({
               'app_qrzlog_logid': extract_adif_column(adif_file, app_qrzlog_logid_col),
               #'app_qrzlog_qsldate': extract_adif_column(adif_file, app_qrzlog_qsldate_col),
               #'app_qrzlog_status': extract_adif_column(adif_file, app_qrzlog_status_col),
               #'band': extract_adif_column(adif_file, band_col),
               #'band_rx': extract_adif_column(adif_file, band_rx_col),
               'call': extract_adif_column(adif_file, call_col),
               #'cnty': extract_adif_column(adif_file, cnty_col),
               #'comment': extract_adif_column(adif_file, comment_col),
               #'cont': extract_adif_column(adif_file, cont_col),
               'country': extract_adif_column(adif_file, country_col),
               #'cqz': extract_adif_column(adif_file, cqz_col),
               #'distance': extract_adif_column(adif_file, distance_col),
               #'dxcc': extract_adif_column(adif_file, dxcc_col),
               #'email': extract_adif_column(adif_file, email_col),
               #'eqsl_qsl_rcvd': extract_adif_column(adif_file, eqsl_qsl_rcvd_col),
               #'eqsl_qsl_sent': extract_adif_column(adif_file, eqsl_qsl_sent_col),
               'freq': extract_adif_column(adif_file, freq_col),
               #'freq_rx': extract_adif_column(adif_file, freq_rx_col),
               'gridsquare': extract_adif_column(adif_file, gridsquare_col),
               #'ituz': extract_adif_column(adif_file, ituz_col),
               #'lat': extract_adif_column(adif_file, lat_col),
               #'lon': extract_adif_column(adif_file, lon_col),
               #'lotw_qsl_rcvd': extract_adif_column(adif_file, lotw_qsl_rcvd_col),
               #'lotw_qsl_sent': extract_adif_column(adif_file, lotw_qsl_sent_col),
               'mode': extract_adif_column(adif_file, mode_col),
               #'my_city': extract_adif_column(adif_file, my_city_col),
               #'my_cnty': extract_adif_column(adif_file, my_cnty_col),
               'my_country': extract_adif_column(adif_file, my_country_col),
               #'my_cq_zone': extract_adif_column(adif_file, my_cq_zone_col),
               'my_gridsquare': extract_adif_column(adif_file, my_gridsquare_col),
               #'my_itu_zone': extract_adif_column(adif_file, my_itu_zone_col),
               #'my_lat': extract_adif_column(adif_file, my_lat_col),
               #'my_lon': extract_adif_column(adif_file, my_lon_col),
               #'my_name': extract_adif_column(adif_file, my_name_col),
               #'name': extract_adif_column(adif_file, name_col),
               'qrzcom_qso_upload_date': extract_adif_column(adif_file, qrzcom_qso_upload_date_col),
               #'qrzcom_qso_upload_status': extract_adif_column(adif_file, qrzcom_qso_upload_status_col),
               #'qsl_rcvd': extract_adif_column(adif_file, qsl_rcvd_col),
               #'qsl_sent': extract_adif_column(adif_file, qsl_sent_col),
               'qso_date': extract_adif_column(adif_file, qso_date_col),
               #'qso_date_off': extract_adif_column(adif_file, qso_date_off_col),
               #'qth': extract_adif_column(adif_file, qth_col),
               'rst_rcvd': extract_adif_column(adif_file, rst_rcvd_col),
               'rst_sent': extract_adif_column(adif_file, rst_sent_col),
               #'state': extract_adif_column(adif_file, state_col),
               'station_callsign': extract_adif_column(adif_file, station_callsign_col),
               'time_off': extract_adif_column(adif_file, time_off_col),
               #'time_on': extract_adif_column(adif_file, time_on_col),
               'tx_pwr': extract_adif_column(adif_file, tx_pwr_col)
               })
    except:
        return None
    return df

def main():
    df = parse_adif(FILE)
    print(f'Extracted {len(df)} rows and {len(df.columns)} columns.\n')

    #export to csv, no index column
    df.to_csv(export_file, index=False)

if __name__ == '__main__':
    main()