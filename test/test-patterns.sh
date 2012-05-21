#!/bin/sh


TMPDIR=`mktemp -d`
mkdir -p $TMPDIR
CMD="zypper -v --no-gpg-checks --non-interactive --gpg-auto-import-keys -R $TMPDIR  "

function setup_repos() {
    test -d "download.tz.otcshare.org"  || (
        wget -m  -I "live/Tizen:/Base/standard/repodata" --no-parent    https://download.tz.otcshare.org/live/Tizen:/Base/standard/repodata
        wget -m  -I "live/Tizen:/Main/standard/repodata" --no-parent    https://download.tz.otcshare.org/live/Tizen:/Main/standard/repodata
    )
    $CMD ar file://$PWD/download.tz.otcshare.org/live/Tizen:/Main/standard/ staging
    $CMD ar file://$PWD/download.tz.otcshare.org/live/Tizen:/Base/standard/ base
}
function show()
{
    setup_repos
    $CMD pt
}
function patterns()
{
    setup_repos
    PATTERNS=$(echo $1 | sed 's/,/ /g')
    $CMD in --dry-run --type pattern $PATTERNS

}
while getopts ":sp:n:c" opt; do
  case $opt in
    n)
      echo "Using new pattern file $OPTARG"
      NEW_PATTERN_FILE=$OPTARG
      ;;
    p)
      echo "$OPTARG" >&2
      PATTERNS=$OPTARG
      ;;
    s)
      SHOW_PATTERNS=1
      ;;
    c)
      CLEAN=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ -z "$1" ]; then
  echo "You need to provide a pattern name as an argument"
  exit 1
fi


if [ -n "$CLEAN" ]; then
   rm -rf download.tz.otcshare.org
fi 

if [ -n "$NEW_PATTERN_FILE" ]; then
    echo "Modifying repos with new pattern $NEW_PATTERN_FILE"
    test -f $NEW_PATTERN_FILE && modifyrepo $NEW_PATTERN_FILE download.tz.otcshare.org/live/Tizen:/Main/standard/repodata
fi
if [ -n "$SHOW_PATTERNS" ]; then
    show
fi
if [ -n "$PATTERNS" ]; then
    patterns $PATTERNS
fi

rm -rf $TMPDIR
