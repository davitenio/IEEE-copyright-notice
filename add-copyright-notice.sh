#!/bin/bash

usage() {
	echo "Usage: $0 PDF YEAR [DOI]"
	echo "DOI is an optional parameter"
}

if [ ! $# == 3 -a ! $# == 2 ]; then
	usage
	exit 1
fi

FILE=$1
YEAR=$2
DOI=$3

if [ -z $DOI ]; then
	sed -e "s/YEAR/$YEAR/" -e "s#DOI##" copyMark.tex > copyMarkTmp.tex
else
	sed -e "s/YEAR/$YEAR/" -e "s#DOI#doi: $DOI#" copyMark.tex > copyMarkTmp.tex
fi

y=${FILE%.pdf}

pdflatex copyMarkTmp.tex

pdftk $FILE cat 1 output - | pdftk - stamp copyMarkTmp.pdf output - | pdftk A=- B=$FILE cat A1 B2-end output ${y}_copy.pdf

rm copyMarkTmp.tex
