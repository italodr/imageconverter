#!/usr/bin/env bash
shopt -s extglob

rm -rf test/

function resizeImage {
  for img in *.@(jpg|png|gif)
  do
    basepath=${img%/*}
    base=${img##*/}
    extension=${base##*.}
    basename=${base%.*}

    mkdir -p test/$basename
    convert $img -resize $1 -quality $2 -background Khaki -pointsize 30 label:"$1 $extension" -gravity Center -append -verbose test/$basename/$basename$3.$extension
    if [ $1 -gt 1 ]; then
      convert $img -resize $1 -quality $2 -background Khaki -pointsize 30 label:"$1 webp" -gravity Center -append -verbose test/$basename/$basename$3.webp
      # convert $img -resize $1 -quality $2 -background Khaki -pointsize 30 label:"$1 jpeg-2000" -gravity Center -append -verbose test/$basename/$basename$3.jp2
    fi
  done
}

# |----------|----------|----------|----------|
# |  size px |   @1.5x  |    @2x   |    @3x   |
# |----------|----------|----------|----------|
# |    320   |    480   |    640   |    960   |
# |    640   |    960   |    1280  |    1920  |
# |    960   |    1440  |    1920  |    2880  |
# |    1280  |    1920  |    2560  |    3840  |
# |    1600  |    2400  |    3200  |    4800  |
# |    1920  |    2880  |    3840  |    5760  |
# |----------|----------|----------|----------|

# sizes=(320 640 960 1280 1600 1920)
# sizes2x=(640 1280 1920 2560 3200 3840)
# sizes3x=(960 1920 2880 3840 4800 5760)
# quality=(70 70 70 70 70 70)

#test
sizes=(320 480 640 960 1280 1440 1600 1920 2400 2560 2880 3200 3840 4800 5760)

resizeImage 1 1 "-pixel"
for (( i = 0; i < ${#sizes[@]}; ++i )); do
  resizeImage ${sizes[i]} 70 "-${sizes[i]}"
done
