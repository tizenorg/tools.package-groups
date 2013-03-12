#!/usr/bin/python

import os, sys

group_template = '''<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns:rpm="http://linux.duke.edu/metadata/rpm"
         xmlns="http://novell.com/package/metadata/suse/pattern">
   <name>@GROUPNAME@</name>
   <summary>@GROUPNAME@</summary>
   <description>@GROUPNAME@</description>
   <uservisible/>
   <category lang="en">@GROUPNAME@</category>
   <rpm:requires>
@PKGS@
   </rpm:requires>
</pattern>
'''

entry_template = '''        <rpm:entry name="@PKGNAME@"/>'''

def main():
    if not len(sys.argv) == 3:
        exit()
    data_file = open(sys.argv[1], 'r')
    group_table = data_file.readlines()
    data_file.close()

    pkg_group_info = []

    pkgs = None 

    group_file = open(os.getcwd() + '/patterns/' + sys.argv[2] + '.xml', 'w')
    group_content = group_template.replace('@GROUPNAME@', sys.argv[2])

    for record_index in range(len(group_table)):
        record = group_table[record_index].replace('\n', '')
        if pkgs is None:
            pkgs = entry_template.replace('@PKGNAME@', record)
        else:
            pkgs = pkgs + '\n' +  entry_template.replace('@PKGNAME@', record)

    group_content = group_content.replace('@PKGS@', pkgs)
    group_file.write(group_content)
    group_file.close()


if __name__ == "__main__":
    main()

