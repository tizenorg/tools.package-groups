#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys
import yaml
import os



for f in os.listdir("patterns"):
    if '.xml' not in f:
        continue
    tree = ET.parse("patterns/%s" %f)

    p = {}
    namespace="http://linux.duke.edu/metadata/rpm"
    pns = 'http://novell.com/package/metadata/suse/pattern'
    n  = tree.find('{%s}name' %pns).text
    if n.startswith("meego-"):
        n = n[6:]
    p['Name']  = n
    s  = tree.find('{%s}summary' %pns).text
    if s.startswith("MeeGo"):
        s = s[5:].lstrip()
    p['Summary']  = s
    p['Description']  = tree.find('{%s}description' %pns).text
    req = tree.findall('.//{%s}entry' % namespace)
    pkgs = []
    for r in req:
        pkgs.append(r.attrib.get("name"))

    p['Packages'] = pkgs
    yf = yaml.dump(p, default_flow_style=False)

    yfn = os.path.basename(f).rpartition(".")[0] + ".yaml"
    if yfn.startswith("meego-"):
        yfn = yfn[6:]
    fp = open("new/%s" %yfn, 'w')
    fp.write(yf)
    fp.close()

