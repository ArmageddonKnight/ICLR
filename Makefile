all: main.pdf Makefile

%.pdf: %.tex
	pdflatex -synctex=1 -interaction=nonstopmode $<
	-bibtex $*.aux
	pdflatex -synctex=1 -interaction=nonstopmode $<
	pdflatex -synctex=1 -interaction=nonstopmode $<

.PHONY: clean upgrade
clean:
	find . -maxdepth 1 \
		\( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
	           -name "*.log" -o -name "*.out" -o -name "*.pdf" -o \
		   -name "*.synctex.gz" \) | xargs $(RM)

YEAR := 2022

upgrade:
	curl -L https://github.com/ICLR/Master-Template/raw/master/archive/iclr${YEAR}.zip -o iclr.zip
	unzip -o iclr.zip iclr${YEAR}/iclr${YEAR}_conference.sty \
	                  iclr${YEAR}/iclr${YEAR}_conference.bst \
	                  iclr${YEAR}/math_commands.tex
	cp iclr${YEAR}/iclr${YEAR}_conference.sty iclr_conference.sty
	cp iclr${YEAR}/iclr${YEAR}_conference.bst iclr_conference.bst
	cp iclr${YEAR}/math_commands.tex math_commands.tex
	rm -rf iclr.zip iclr${YEAR}
