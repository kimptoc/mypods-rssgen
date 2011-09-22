#!/bin/bash

cd /home/kimptoc/public_html/radioshifted/scripts

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
  echo '<enclosure url="http://home.kimptoc.net:8080/radioshifted/mypods/'$MP3FILE'" type="audio/mpeg" length="0" />' >>$MP3RSS
  echo "</item>" >> $MP3RSS
}

cd ../mypods/

for FILE in *.mp3; do
  writeRssPart $FILE
done

#Assemble parts into complete RSS feed
cat ../scripts/my.rss.header > my.rss

for PART in *dio4*.rss; do
  cat $PART >> my.rss
done

cat ../scripts/my.rss.footer >> my.rss

cat ../scripts/my.rss.header2 > my2.rss

for PART in *dio2*.rss; do
  cat $PART >> my2.rss
done

cat ../scripts/my.rss.footer >> my2.rss


