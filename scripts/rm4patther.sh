#!/bin/sh

usage()
{
	echo Usage: rm4patthern.sh {pattern.xml} {package name}
}

if [ $# -lt 2 ]; then
	usage
	exit 0
fi

PATTERN_XML=$1
PACKAGE_NAME=$2

if [ ! -f $PATTERN_XML ]; then
	echo "Pattern file($PATTERN_XML) is not exist"
	exit 1
fi

PATTERN_XML_BASENAME=$(basename $PATTERN_XML)
PATTERN_HEAD=/tmp/$PATTERN_XML_BASENAME.head
PATTERN_TAIL=/tmp/$PATTERN_XML_BASENAME.tail
PATTERN_LIST=/tmp/$PATTERN_XML_BASENAME.list
PATTERN_LIST_RM=$PATTERN_LIST.rm
PATTERN_LIST_RM_XML=$PATTERN_LIST_RM.xml

head -n 9 $PATTERN_XML > $PATTERN_HEAD
tail -n 2 $PATTERN_XML > $PATTERN_TAIL
grep '<rpm:entry' $PATTERN_XML | cut -f 2 -d '"' | sort | uniq > $PATTERN_LIST

grep -v "^${PACKAGE_NAME}$" $PATTERN_LIST > $PATTERN_LIST_RM

if [ $(cat  $PATTERN_LIST | wc -l) -eq $(cat $PATTERN_LIST_RM | wc -l) ]; then
	echo "Package($PACKAGE_NAME) doesn't exit in pattern file($PATTERN_XML)"
	exit 0
fi

cat $PATTERN_LIST_RM | sed 's/^/        <rpm:entry name="/' | sed 's/$/"\/>/' > $PATTERN_LIST_RM_XML

cp $PATTERN_XML /tmp/

cat $PATTERN_HEAD > $PATTERN_XML
cat $PATTERN_LIST_RM_XML >> $PATTERN_XML
cat $PATTERN_TAIL >> $PATTERN_XML

diff -uNp /tmp/$PATTERN_XML_BASENAME $PATTERN_XML

