#!/bin/bash

echo "Running $0 at `date`"

export SCRIPT_DIR=/Users/family/Sites/box/hijacked/scripts/

cd $SCRIPT_DIR

function writeRssPart()
{
  MP3FILE=$1

  MP3RSS=${MP3FILE}.rss

  if [ ! -f $MP3FILE ]; then
    # no mp3 file - so give up
    return
  fi

  if [ -f $MP3RSS ]; then
    # rss file is there already, so do nothing
    return
  fi

  PUBDATE=`date +"%d %b %C%y %H:%M:%S GMT"`

  echo "Processing file $MP3FILE"
    echo "<item><title>$MP3FILE</title>" >>$MP3RSS
  echo "<pubDate>$PUBDATE</pubDate>" >>$MP3RSS
  echo "<guid isPermaLink='false'>$MP3FILE</guid>" >>$MP3RSS
  echo '<enclosure url="http://home.kimptoc.net:8080/hijacked/podcast/'$MP3FILE'" type="audio/mpeg" length="0" />' >>$MP3RSS
  echo "</item>" >> $MP3RSS
}

cd ../podcast

find archived -ctime +120 -exec rm {} \;
find . -depth 1 -ctime +60 -exec mv {} archived \;

for FILE in *.mp3; do
  writeRssPart $FILE
done

#Assemble parts into complete RSS feed

# Radio 4 rss

cat $SCRIPT_DIR/my.rss.header > my.rss

for PART in *dio4*.rss; do
  cat $PART >> my.rss
done

cat $SCRIPT_DIR/my.rss.footer >> my.rss

# Radio 2 rss

cat $SCRIPT_DIR/my.rss.header2 > my2.rss

for PART in *dio2*.rss; do
  cat $PART >> my2.rss
done

for PART in *dioLondon*.rss; do
  cat $PART >> my2.rss
done

cat $SCRIPT_DIR/my.rss.footer >> my2.rss

# ClassicFM rss

cat $SCRIPT_DIR/my-classics.rss.header > my-classics.rss

for PART in Radio3*.rss; do
  cat $PART >> my-classics.rss
done

for PART in ClassicFM*.rss; do
  cat $PART >> my-classics.rss
done

cat $SCRIPT_DIR/my.rss.footer >> my-classics.rss


echo "Finished running $0 at `date`"
echo "."
