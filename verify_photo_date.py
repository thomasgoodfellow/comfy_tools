# photos_in_date_tree.py
#
# Restructure directory tree of photos into a single list of date-named directories (YYYY-MM-DD) containing
# photos taken on that date. Possible problems with photos include:
#  (1) photo has plausible date that doesn't match the directory date, e.g. from unset camera date but has
#      been copied to the correct data-named folder. 
#  (2) photo has plausible date that doesn't match the directory date


import os
from PIL import Image
from PIL.ExifTags import TAGS
import re
from calendar import monthrange
import datetime
import exifread

dateTpl = re.compile("^(\d\d\d\d)-(\d\d)(-\d\d)?$")

#print(len(dateTpl.match("2010-01-01").groups()[1]))
#print(len(dateTpl.match("2010-01").groups()[1]))

dateKey = "EXIF DateTimeOriginal"
fDate = datetime
lDate = datetime
for root, dirs, files in os.walk(r'D:\TomLibraries\Pictures\pix\from_sx260'):
#    print root
    path = root.split(os.sep)
    finalDir = path[-1:][0]
    dateM = dateTpl.match(finalDir)
    if dateM:
        print(finalDir)
        year = int(dateM.group(1))
        month = int(dateM.group(2))
        if dateM.group(3) != None:
            firstDay = lastDay = int(dateM.group(3)[1:])
        else:
            firstDay = 1
            lastDay = monthrange(year, month)[1]
        firstDate = datetime.date(year, month, firstDay)
        lastDate = datetime.date(year, month, lastDay)
        for file in files:
            if file.lower()[-3:] == "jpg" or file.lower()[-4:] == "jpeg":
                ffile = root + "\\" + file
                tags = Image.open
                fh = open(ffile, 'rb')
                tags = exifread.process_file(fh, details=False, stop_tag=dateKey)
                if dateKey in tags:
                    fileDate = datetime.datetime.strptime(str(tags[dateKey]), "%Y:%m:%d %H:%M:%S").date()
                    if not(fileDate >= firstDate and fileDate <= lastDate):
                        print(file)


