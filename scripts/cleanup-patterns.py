#!/usr/bin/python

import yaml
import sys, os
import optparse


def sort_pkgs(patterns_dir='patterns'):
    for f in os.listdir(patterns_dir):
        if not f.endswith('.yaml'):
            continue
        print f
        stream = file("%s/%s" %(patterns_dir,f), 'r+')
        y = yaml.load(stream)
        if y.has_key('Packages'):
            y['Packages'] = sorted(y['Packages'])
            yf = yaml.dump(y, default_flow_style=False)
            stream.seek(0)
            stream.write(yf)
        stream.close()

        

if __name__ == '__main__':
    parser = optparse.OptionParser()

    parser.add_option("-s", "--sort", action="store_true", default=False,
                    help="sort packages")
        
    (options, args) = parser.parse_args()

    if options.sort:
        sort_pkgs()

