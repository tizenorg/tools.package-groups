#!/bin/sh

if [ -z "$1" ]; then
  echo "You need to provide a pattern name as an argument"
  exit 1
fi
PATTERN=$@
TMPDIR=`mktemp -d`
mkdir -p $TMPDIR
CMD="zypper --gpg-auto-import-keys -R $TMPDIR  "
$CMD ar http://download.meego.com/snapshots/1.1.90.3.20110216.81/oss/repos/ia32/packages/ oss
$CMD ar http://download.meego.com/snapshots/1.1.90.3.20110216.81/non-oss/repos/ia32/packages/ non-oss
$CMD in --dry-run --type pattern $PATTERN 

rm -rf $TMPDIR
