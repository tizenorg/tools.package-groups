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
    if not len(sys.argv) == 2:
        exit()
    data_file = open(sys.argv[1], 'r')
    group_table = data_file.readlines()
    data_file.close()

    pkg_group_info = []

    for record_index in range(len(group_table)):
        record = group_table[record_index].replace('\n', '')
        if record_index == 0:
            group_names = record.split(',')
        else:
            pkg_info = record.split(',')
            pkgname = pkg_info[0]
            groupnum = 0
            for index in range(len(pkg_info)):
                if pkg_info[index] is not None and pkg_info[index] == "x":
                    groupnum = index
                    break
            if groupnum == 0:
                print('package not involved : ' + pkgname)
            else: 
                pkg_group_info.append([pkgname, groupnum])

    for group_index in range(len(group_names)):
        if group_index == 0:
            continue
        group_file = open(os.getcwd() + '/patterns/' + group_names[group_index] + '.xml', 'w')
        group_content = group_template.replace('@GROUPNAME@', group_names[group_index])
        pkgs = None 
        for item in pkg_group_info:
             if item[1] == group_index:
                 if pkgs is None:
                      pkgs = entry_template.replace('@PKGNAME@', item[0])
                 else:
                     pkgs = pkgs + '\n' +  entry_template.replace('@PKGNAME@', item[0])

        group_content = group_content.replace('@PKGS@', pkgs)
        group_file.write(group_content)
        group_file.close()


if __name__ == "__main__":
    main()

