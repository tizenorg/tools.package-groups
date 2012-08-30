#!/bin/sh

usage()
{
	echo "Usage: add2patthern.sh {pattern.xml} {package name} [-f]"
}

if [ $# -lt 2 ]; then
	usage
	exit 0
fi

PATTERN_XML=$1
PACKAGE_NAME=$2
FORCE_ADD=$3

if [ ! -f $PATTERN_XML ]; then
	echo "Pattern file($PATTERN_XML) is not exist"
	exit 1
fi

PATTERN_XML_BASENAME=$(basename $PATTERN_XML)
PATTERN_HEAD=/tmp/$PATTERN_XML_BASENAME.head
PATTERN_TAIL=/tmp/$PATTERN_XML_BASENAME.tail
PATTERN_LIST=/tmp/$PATTERN_XML_BASENAME.list
PATTERN_LIST_ADD=$PATTERN_LIST.add
PATTERN_LIST_ADD_XML=$PATTERN_LIST_ADD.xml

head -n 9 $PATTERN_XML > $PATTERN_HEAD
tail -n 2 $PATTERN_XML > $PATTERN_TAIL
grep '<rpm:entry' $PATTERN_XML | cut -f 2 -d '"' | sort | uniq > $PATTERN_LIST

MATCHED=$(grep -c "^$PACKAGE_NAME$" $PATTERN_LIST)
if [ $MATCHED -gt 0 ]; then
	echo "Package($PACKAGE_NAME) already exist in pattern file($PATTERN_XML)"
	exit 0
fi

echo "Checking whether package($PACKAGE_NAME) exists."
FOUND=$(osc ls -b Tizen:2.0:Main -r standard | cut -f2 -d " " | grep -c "^$PACKAGE_NAME.rpm$")
FOUND=$(($FOUND + $(osc ls -b Tizen:2.0:Base -r standard | cut -f2 -d " " | grep -c "^$PACKAGE_NAME.rpm$")))

if [ $FOUND -eq 0 ] && [ "$FORCE_ADD" != "-f" ]; then
        echo "Package($PACKAGE_NAME) not found in repository"
        exit 1
fi

echo $PACKAGE_NAME >> $PATTERN_LIST
cat $PATTERN_LIST | sort | uniq > $PATTERN_LIST_ADD

cat $PATTERN_LIST_ADD | sed 's/^/        <rpm:entry name="/' | sed 's/$/"\/>/' > $PATTERN_LIST_ADD_XML

cp $PATTERN_XML /tmp/

cat $PATTERN_HEAD > $PATTERN_XML
cat $PATTERN_LIST_ADD_XML >> $PATTERN_XML
cat $PATTERN_TAIL >> $PATTERN_XML

diff -uNp /tmp/$PATTERN_XML_BASENAME $PATTERN_XML

