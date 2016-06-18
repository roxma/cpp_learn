#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
inputString = sys.stdin.read()
import re
pattern = re.compile(r'\s+')
hexString = re.sub(pattern, '', inputString)
sys.stdout.write(hexString.decode("hex"))

