#!/bin/bash

ARCH=$1
mkdir new
for i in `ls -1 patterns/*.xml`; do 
    base=`basename $i`
    xsltproc --stringparam arch $ARCH  xsl/filter.xsl  $i >  new/$base
done
echo "<index>" > INDEX.xml;
for i in `ls -1 new/*.xml`; do echo "<file>$i</file>" >> INDEX.xml; done; 
echo "</index>" >> INDEX.xml
xsltproc xsl/merge.xsl INDEX.xml  > patterns.xml 
xsltproc xsl/comps.xsl patterns.xml > group.xml
rm -rf new
