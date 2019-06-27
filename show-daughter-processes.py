#!/usr/bin/python

# Shows all daughter processes launched from a given process invocation
# If the first argument is "-d" then debugs the first daughter process

import sys
import os
if len(sys.argv) == 1:
    sys.exit("Give a command+args to see what daughter processes are launched. Prepend this with -d to debug the first such daughter with cgdb")
dbgit = False
if sys.argv[1] == '-d':
    dbgit = True
    del sys.argv[1]
from subprocess import Popen, PIPE
cmd = ['strace', '-s10000', '-f', '-e', 'trace=process'] + sys.argv[1:]
p = Popen(cmd, stdout=PIPE, stderr=PIPE)
stdout, stderr = p.communicate()
lines = stderr.split("\n")
import re
cmdCnt = 1
for L in lines:
#    print L
    m = re.match('\[pid\s*\d+\] execve\(\"[^\"]+\", \[(.+)\], \[.+\] <unfinished.+>', L)
    if not m:
        m = re.match('\[pid\s*\d+\] execve\(\"[^\"]+\", \[(.+)\], \[.+\]\) =', L)
    if m:
        a = m.group(1).split("\", \"")
        cmd = ' '.join(a)
        cmd = cmd[1:-1]
        if dbgit:
            cmd = 'cgdb -d /space/user/thomasg/gdb-8.1/gdb/gdb --data-directory=/space/user/thomasg/gdb-8.1/gdb/data-directory --args ' + cmd
            print 'Exec: ' + cmd
            sys.exit(os.system(cmd))
        print "#" + str(cmdCnt) + "\n" + cmd
        cmdCnt += 1
