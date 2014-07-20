#!/bin/bash

usage() {
	echo "Usage: $0 PDF YEAR DOI"
}

if [ ! $# == 3 ]; then
	usage
	exit 1
fi

FILE=$1
YEAR=$2
DOI=$3

sed -e "s/YEAR/$YEAR/" -e "s#DOI#$DOI#" copyMark.tex > copyMarkTmp.tex

y=${FILE%.pdf}

pdflatex copyMarkTmp.tex

pdftk $FILE cat 1 output - | pdftk - stamp copyMarkTmp.pdf output - | pdftk A=- B=$FILE cat A1 B2-end output ${y}_copy.pdf

rm copyMarkTmp.tex

evince ${y}_copy.pdf&
