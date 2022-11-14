#!/bin/bash
# convert latex book to pdf

GREEN='\033[0;32m'
COLOR_OFF="\033[0m"
UNDERLINED="\033[4m"

if [ ! -f "./book.tex" ]; then
  echo "No LaTeX book found. Please use make-latex.sh script to generate the book, before converting to PDF."
  exit 1
fi

printf "Exporting ./book.tex in PDF format:"

pandoc -N --quiet -V documentclass=book -V "geometry=margin=1.2in" \
   -V mainfont="GFS Didot" -V sansfont="GFS Didot" -V monofont="GFS Didot" \
   -V fontsize=12pt -V version=2.0 \
   --metadata-file=meta.yml book.tex \
   --pdf-engine=xelatex --toc -o book.pdf

printf "            \t\t\t${GREEN}Done${COLOR_OFF}\n"

printf "PDF ebook generated:\n\t${GREEN}${UNDERLINED}./book.pdf${COLOR_OFF}\n"


