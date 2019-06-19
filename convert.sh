#!/usr/bin/env bash
shopt -s nullglob

BASE_PATH=images
DEST_PATH=dist
QUALITY=70
SIZES=(150 450 650)
SIZES_NAME=(thumb small medium)

rm -rf $DEST_PATH

resizeImage() {
  basepath=${1%/*}
  base=${1##*/}
  extension=${base##*.}
  basename=${base%.*}
  destPath=${basepath/images/$DEST_PATH}

  echo "  — Processing image ${basename}";
  for (( i = 0; i < ${#SIZES[@]}; ++i )); do
    newDestPath=$destPath/${SIZES_NAME[i]}
    mkdir -p $newDestPath
    mkdir -p $destPath/full
    convert $1 $destPath/full/$basename.$extension
    convert $1 $destPath/full/$basename.webp
    convert $1 -resize ${SIZES[i]} -quality $QUALITY $newDestPath/$basename.$extension
    convert $1 -resize ${SIZES[i]} -quality $QUALITY $newDestPath/$basename.webp
  done
}

imageParser() {
  for f in $1/*
  do
    if [ -d "${f}" ] ; then
        echo "\n— Working on directory: ${f}";
        imageParser $f
    else
        if [ -f "${f}" ]; then
            resizeImage $f
        else
            echo "— Invalid file: ${f}";
            exit 1
        fi
    fi
  done
}

imageParser $BASE_PATH
