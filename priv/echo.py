#!/bin/env python

import sys 
import time

while 42:
    line = sys.stdin.readline()
    if not line: break

    response = "{got:\"" + line.rstrip() + "\",\n" + \
               " now:\"" + time.ctime()  + "\"}\n" + \
               "COMMIT\n"

    sys.stdout.write(response)

    sys.stdout.flush()

