#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys

tree1 = ET.parse(sys.argv[1])
tree2= ET.parse(sys.argv[2])

namespace="http://linux.duke.edu/metadata/rpm"
req1 = tree1.findall('.//{%s}entry' % namespace)
req2 = tree2.findall('.//{%s}entry' % namespace)
l2 = []
l1 = []
for r in req1:
    l1.append(r.attrib.get("name"))
for r in req2:
    l2.append(r.attrib.get("name"))

s1 = set(sorted(l1))
s2 = set(sorted(l2))
intersection = s1 & s2
for i in intersection:
    print i
