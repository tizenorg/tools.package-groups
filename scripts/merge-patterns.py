#!/usr/bin/python

import yaml
import sys, os
import optparse
from lxml import etree




def create_patterns(arch='i586', split=False, patterns_dir='patterns'):

    rpm_ns="http://linux.duke.edu/metadata/rpm"
    pattern_ns="http://novell.com/package/metadata/suse/pattern"
    PATTERN = "{%s}" % pattern_ns
    if not split:	
        xmlroot = etree.Element("patterns")
        NSMAP = {None : pattern_ns, "rpm": rpm_ns, "patterns": pattern_ns}
    else:
        NSMAP = {None : pattern_ns, "rpm": rpm_ns}

    count = 0
    for f in os.listdir(patterns_dir):
        if not f.endswith('.yaml'):
            continue
        print "Working on %s" %f
        count = count + 1
        stream = file("%s/%s" %(patterns_dir,f), 'r')
        y = yaml.load(stream)
        if y.has_key('Arch') and y['Arch'] != arch:
            print "Skipping pattern '%s' because architecture doesn't match ('%s' vs '%s')." % (y['Name'], y['Arch'], arch)
            continue
        if split:
            proot = etree.Element("pattern", nsmap=NSMAP)
        else:
            proot = etree.SubElement(xmlroot, "pattern",  nsmap=NSMAP)

        etree.SubElement(proot, "name").text = y['Name']
        etree.SubElement(proot, "summary").text = y['Summary']
        etree.SubElement(proot, "description").text = y['Description']
        etree.SubElement(proot, "uservisible")
        cat = etree.SubElement(proot, "category")
        cat.text = "Base Group"
        cat.set("lang", "en")
        req = etree.SubElement(proot, "{%s}requires" %rpm_ns)
        if y.has_key('Patterns'):
            collect = []
            for pat in y['Patterns']:
                if os.path.exists("%s/%s.yaml" %(patterns_dir, pat)):
                    pf = file("%s/%s.yaml" %(patterns_dir, pat), 'r')
                    pfy = yaml.load(pf)
                    if pfy.has_key('Packages'):
                        collect += pfy['Packages']
        elif y.has_key('Packages'):
            collect = y['Packages']

        for p in collect:
            if type(p).__name__=='dict':
                a = p.values()[0]
                if a == arch:
                    entry = etree.SubElement(req, "{%s}entry" %rpm_ns)
                    entry.set("name", p.keys()[0])
                    entry.set("arch", arch)
            else:
                entry = etree.SubElement(req, "{%s}entry" %rpm_ns)
                entry.set("name", p)
        if split:
            tree = etree.ElementTree(proot)
            tree.write("%s.xml" %y['Name'], pretty_print=True)

    if not split:
        xmlroot.set('count', "%d" %count)
        tree = etree.ElementTree(xmlroot)
        tree.write("patterns.xml")


if __name__ == '__main__':
    parser = optparse.OptionParser()

    parser.add_option("-a", "--arch", type="string", dest="arch",
                    help="architecture")
    parser.add_option("-s", "--split", action="store_true", dest="split", default=False,
                    help="split patterns into single files")
        
    (options, args) = parser.parse_args()

    if options.arch and options.arch in ['i586', 'arm']:
        create_patterns(arch=options.arch, split=options.split)

