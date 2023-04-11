#!/usr/bin/python

import os
import subprocess
import argparse
from os.path import splitext
from datetime import datetime
from PIL import Image
from PIL.ExifTags import TAGS
import sys

def dump(obj):
  for attr in dir(obj):
    print("obj.%s = %r" % (attr, getattr(obj, attr)))
    
def get_field (exif,field) :
  for (k,v) in exif.items():
     if TAGS.get(k) == field:
        return v
        
def fotoHash(name, dir, size):
    hstr = name + str(size)
    return hash(hstr)

class Foto():
    def __init__(self, name, dir, size, takenDT, setLWT):
        self.name = name
        self.dir = dir
        self.size = size
        self.taken = takenDT
        self.setLWT = setLWT
        self.hash = fotoHash(name, "", size)
    def __eq__(self, other):
       if not other or self.name != other.name or self.size != other.size:
          return False
       # shenanigans with timestamps of files copied to/from FAT systems
       if self.taken > other.taken:
          dd = self.taken - other.taken
       else:
          dd = other.taken - self.taken
#       if dd.seconds > 2:
#          print(f'dt = {dd.seconds}')
       return dd.seconds <= 3
    def __ne__(self, other):
        return not self.__eq__(other)
    def __hash__(self):
        return self.hash
    
keepableExtensions = { '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.wav', '.mp4', '.mpg', '.mov', '.avi' }

# Scan directory tree and return list of Foto objects
def scanDir(dir, useExif):
    fotos = set()
    n = 0
    for root, dirs, files in os.walk(dir):
#        path = root.split(os.sep)
#        print((len(path) - 1) * '---', os.path.basename(root))
        for file in files:
            n += 1
            if n % 100 == 0:
                print(f'...{n}\r', end='')
            name, extension = splitext(file)
            extension = extension.lower()
            if extension in keepableExtensions:
                path = root + os.sep + file
                size = os.path.getsize(path)
                mTime = datetime.fromtimestamp(os.path.getmtime(path))
                setLWT = False
                if extension == ".jpg" or extension == ".jpeg":
                    if useExif:
                        try:
                            image = Image.open(path)
                            if image:
                                exif = image.getexif()
                                if exif:
                                    exifDT = get_field(exif, 'DateTimeOriginal')
                                    if exifDT:
                                        mTime = datetime.strptime(exifDT, '%Y:%m:%d %H:%M:%S')
                                        setLWT = True   # set the file's modification time to match the ExIf, for faster subsequent evaluations
                        except:
                            print(path + " lacks EXIF DateTimeOriginal; using file date")
                fotos.add(Foto(file, root, size, mTime, setLWT))
    return fotos
    
def deDup(newFotos, libFotos):
    removees = []
#    for f in newFotos:
#        print(f'{f.name}, {f.size}, {f.hash}');
#    for f in libFotos:
#        print(f'{f.name}, {f.size}, {f.taken}, {f.hash}');
    for f in newFotos:
        eQ = False
        for g in libFotos:
            if f.__eq__(g):
                eQ = True
        if eQ != (f in libFotos):
            print("Mismatch")
        if f in libFotos:
            removees.append(f)
#        else:
#            dump(f)
            
    for f in removees:
        newFotos.remove(f)

def generateMovieScript(newFotos, libDestDir, moveFile):
    fileOp = 'move' if moveFile else 'copy'
    newFotos = sorted(newFotos, key=lambda Foto: Foto.taken)
    n = 0
    scr = ''
    for f in newFotos:
        dstDir = f'{libDestDir}\{f.taken.year}-{f.taken.month:02d}-{f.taken.day:02d}'
        dstPath = f'{dstDir}\{f.name}'
        scr += f'if not exist "{dstDir}\" mkdir "{dstDir}"\n'
        scr += f'if not exist "{dstPath}" {fileOp} /-Y "{f.dir}\{f.name}" "{dstPath}"\n'
        if f.setLWT:
            LWT = f'{f.taken.year}/{f.taken.month:02d}/{f.taken.day:02d} {f.taken.hour:02d}:{f.taken.minute:02d}:{f.taken.second:02d}'
            scr += f'powershell (ls \\"{dstPath}\\").LastWriteTime = Get-Date -Format \\"yyyy/MM/dd HH:mm:ss\\" \\"{LWT}\\"\n'
#        scr += f'ren {f.dir}\{f.name} {f.name}.done\n'
        n += 1
        if n % 10 == 0:
            scr += f'echo ...{n}\n'
    return scr
    
    
parser = argparse.ArgumentParser(description='Copy only new photos from a photo source (camera) to the structured image library.')
parser.add_argument('srcDir', help='camera or transfer directory')
parser.add_argument('libDir', help='base of per-day photo library directory')
parser.add_argument('--slow-lib-scan', action='store_true', help='use EXIF data in library for date-taken instead of (quicker) file modification date')
parser.add_argument('--doItNow', action='store_true', help='if not copied immediately then you can first inspect or modify the copying script')
args = parser.parse_args()
    
srcDir = args.srcDir
print(f'Scanning source {srcDir}...')
srcF = scanDir(srcDir, True)
print("...{:1} source images".format(len(srcF)))

libDir = args.libDir
print(f'Scanning library {libDir}...')
libF = scanDir(libDir, args.slow_lib_scan)
print("...{:1} library images".format(len(libF)))

print("De-duplicating source...")
withDupCnt = len(srcF)
deDup(srcF, libF)
print("...removed {:1} duplicates".format(withDupCnt - len(srcF)))

import os
import tempfile

scr = generateMovieScript(srcF, libDir, False)
fd, path = tempfile.mkstemp(suffix=".cmd", dir=".", text=True)
try:
    with os.fdopen(fd, 'w') as tmp:
        tmp.write("@echo off\n")
        tmp.write(scr)
        tmp.close()
        print("Script file to copy photos written to " + path)
        if args.doItNow:
            input("Press ENTER to run the script (consider checking it first) or CTRL+C to cancel now")
            print("Running script - wait for it to complete")
            subprocess.call([path])
            print("Script completed - check results, e.g. in Picasa")
            input("Press ENTER to conclude")
        else:
            print("Check script file contents, then run it to perform copies")
except:
    os.remove(path)


