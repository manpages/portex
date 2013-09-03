#!/bin/env python

import sys 
import time

while 42:
    line = sys.stdin.readline()
    if not line: break

    print("{got: \"",line.rstrip(),"\",", sep='')
    print(" bytes: \"",len(line),"\",", sep='')
    print(" time: \"",time.ctime(),"\"}", sep='')
    print("COMMIT")
    sys.stdout.flush()

