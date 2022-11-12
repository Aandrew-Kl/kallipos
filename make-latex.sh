#!/bin/bash
#assemble and preprocess all the sources files

GREEN='\033[0;32m'
COLOR_OFF="\033[0m"
UNDERLINED="\033[4m"

mkdir -p latex

printf "Creating ./latex directory:"
if [ ! -d "./latex" ]; then
  mkdir ./latex
fi
printf "      \t\t\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Converting ./text/intro.txt to LaTeX:"
pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/00_pre.tex
printf " \t\t\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Converting ./text/pre.txt to LaTeX:"
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/01_intro.tex
printf "  \t\t\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Converting all chapters found in ./text/ to LaTeX:"
for file in text/ch*.txt; do
   [ -e "$file" ] || continue
   pandoc --lua-filter=extras.lua "$file" --to markdown | \
      pandoc --lua-filter=extras.lua --to markdown | \
      pandoc --lua-filter=epigraph.lua --to markdown | \
      pandoc --lua-filter=figure.lua --to markdown | \
      pandoc --lua-filter=footnote.lua --to markdown | \
      pandoc --lua-filter=complexity.lua --to markdown | \
      pandoc --filter pandoc-fignos --to markdown | \
      pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$file" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"02_$(basename "$file" .txt).tex"
done
printf "\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Converting ./text/epi.txt to LaTeX:"
pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/03_epi.tex
printf "  \t\t\t\t${GREEN}Done${COLOR_OFF}\n"
sed -i 's/Figure/Εικόνα/g' ./latex/02_ch0*.tex

printf "Converting all appendices found in ./text/ to LaTeX:"
for file in text/apx*.txt; do
   [ -e "$file" ] || continue
   pandoc --lua-filter=extras.lua "$file" --to markdown | \
      pandoc --lua-filter=extras.lua --to markdown | \
      pandoc --lua-filter=epigraph.lua --to markdown | \
      pandoc --lua-filter=figure.lua --to markdown | \
      pandoc --lua-filter=complexity.lua --to markdown | \
      pandoc --filter pandoc-fignos --to markdown | \
      pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$file" .txt).bib" --reference-location=section --to latex > latex/"04_$(basename "$file" .txt).tex"
done

printf "\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Combining generated LaTeX files in single book:"

pandoc -s latex/*.tex -o book.tex
printf "\t\t\t${GREEN}Done${COLOR_OFF}\n"

printf "Exporting ./book.tex in PDF format:"
pandoc -N --quiet -V documentclass=book -V "geometry=margin=1.2in" \
   -V mainfont="GFS Didot" -V sansfont="GFS Didot" -V monofont="GFS Didot" \
   -V fontsize=12pt -V version=2.0 book.tex \
   --metadata-file=meta.yml \
   --pdf-engine=xelatex --toc -o book.pdf
printf "            \t\t\t${GREEN}Done${COLOR_OFF}\n"

echo ""
echo "LaTeX files generated:"
for file in latex/*; do
   printf "${GREEN}${UNDERLINED}\t./${file}${COLOR_OFF}\n";
done

printf "LaTeX ebook generated:\n\t${GREEN}${UNDERLINED}./book.tex${COLOR_OFF}\n" 
printf "PDF ebook generated:\n\t${GREEN}${UNDERLINED}./book.pdf${COLOR_OFF}\n"
