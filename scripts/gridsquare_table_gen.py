import csv

'''
used to generate a static list of 32,400 4-digit maidenhead gridsquares and their lon/lat conversions
and dump to a csv file for upload to db
'''

def grid_gen():
    '''
    generate letletnumnum list 
    where A-R can appear in the first two places and 0-9 can appear in last two places
    e.g., AA00, AA01...AA99, AB00, AB01...RR99
    '''

    let_list = []
    for x in range(18):
        init_let='A'
        first=f'{chr(ord(init_let) + x)}'

        for y in range(18):
            final=f'{first}{chr(ord(init_let) + y)}'
            let_list.append(final)

    num_list = []
    for i in range(100):
        if i < 10:
            num_list.append(f'0{str(i)}')
        if i > 9:
            num_list.append(i)

    fin_list = []
    for x in range(len(let_list)):
        first = let_list[x]

        for y in range(len(num_list)):
            final = f'{first}{num_list[y]}'
            fin_list.append(final)
    
    return(fin_list)

def to_location(grid):
    # takes grid string and returns top-left lat, lon of grid square
    # modified from https://github.com/space-physics/maidenhead
    
    grid = grid.strip().upper()

    N = len(grid)
    if not 8 >= N >= 2 and N % 2 == 0:
        raise ValueError('Maidenhead locator requires 2-8 characters, even number of characters')

    Oa = ord('A')
    lon = -180.0
    lat = -90.0
    # first pair - world
    lon += (ord(grid[0]) - Oa) * 20
    lat += (ord(grid[1]) - Oa) * 10
    # second pair - region
    if N >= 4:
        lon += int(grid[2]) * 2
        lat += int(grid[3]) * 1
     # third pair - metro
    if N >= 6:
        lon += (ord(grid[4]) - Oa) * 5.0 / 60
        lat += (ord(grid[5]) - Oa) * 2.5 / 60
    return lat, lon

def lon_lat_gen(fin_list):
    fin_geo_list = []
    
    for i in range(len(fin_list)):
        lat, lon = to_location(fin_list[i])
        fin_geo_list.append(f'({lon}, {lat})')

    return(fin_geo_list)

def main():
    grid_list = grid_gen()
    final_geo_list = lon_lat_gen(grid_list)

    print(f'{len(grid_list)} items written')

    with open('gridsquare_lon_lat.csv', mode='w') as csv_file:
        writer = csv.writer(csv_file)
        headers = ['grid', 'lon_lat']
        writer.writerow(headers)
        writer.writerows(zip(grid_list, final_geo_list))    

if __name__ == '__main__':
    main()

