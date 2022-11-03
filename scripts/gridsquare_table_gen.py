import csv

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

fin_lat_list = []
fin_lon_list = []
for i in range(len(fin_list)):
    lat, lon = to_location(fin_list[i])
    fin_lat_list.append(lat)
    fin_lon_list.append(lon)

print(fin_lat_list)

print(f'{len(fin_list)} items written')

with open('gridsquare_lat_lon.csv', mode='w') as csv_file:
    writer = csv.writer(csv_file)
    headers = ['grid', 'lat', 'lon']
    writer.writerow(headers)
    writer.writerows(zip(fin_list, fin_lat_list, fin_lon_list))    
