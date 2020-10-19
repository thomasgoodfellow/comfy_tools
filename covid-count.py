#!/usr/bin/python

# covid-count.py
#
# Boils the "RKI COVID19" CSV data down to a table:
#   | Date | Area - New Case | Area New Death |
# where multiple areas might exist as aggregates of Landkreise,
# but initially it's just Oldenburg
# Date used is Refdatum (col 14), LK (col 4), case (col 7), death (col 8)

from operator import itemgetter
from datetime import datetime, timedelta
#import urllib
#uw = url.request.urlopen('https://raw.githubusercontent.com/datasets/covid-19/master/data/countries-aggregated.csv')
import sys
import csv
import re
if len(sys.argv) < 2:
    sys.exit("Args: <rki-cov19-csv> [<col> <pattern>]")
if len(sys.argv) == 4:
    filterCol = int(sys.argv[2]);
    filterPat = sys.argv[3];
else:
    filterCol = 0
    filterPat = '.*'
with open(sys.argv[1], newline='') as f:
    rw = csv.reader(f)
    rowNum = 0
    cnt = []
    for row in rw:
        if rowNum > 0:
          if not re.search(filterPat, row[filterCol]):
            continue
          dt = datetime.strptime(row[13], '%Y/%m/%d %H:%M:%S')
          cnt += [( dt, row[3], row[6], row[7] )]
        rowNum += 1
    cnt.sort(key=itemgetter(0, 1))
    full = []
    start = cnt[0][0]
    end = cnt[-1][0]
    delta = timedelta(days=1)
    d = start
    while d <= end:
        full += [ [d, 0, 0] ]
        d += delta
#    cnt += [( '2120/1/1', '~trailer~', 0, 0 )]
    print('Infection date,Case,Death')
    for c in cnt:
        i = c[0] - start
        i = i.days
        full[i][1] += int(c[2])
        full[i][2] += int(c[3])
    for f in full:
        d = f[0].strftime('%d/%m/%Y')
        print(f"{d},{f[1]},{f[2]}")


#    prevDate = ''
#    prevLK = ''
#    totCase = 0
#    totDeath = 0
#    for c in cnt:
#        if prevDate != c[0]:# or prevLK != c[1]:
#            if prevLK.find('Oldenburg') >= 0:
#            dt = c[0].split(' ')
#            dt = dt[0].split('/')
#            dt = dt[2]+'/'+dt[1]+'/'+dt[0]
#            print(f"{dt},{totCase},{totDeath}")
#            prevDate = dt
#            prevLK = c[1]
#            totCase = 0
#            totDeath = 0
#        totCase += int(c[2])
#        totDeath += int(c[3])
