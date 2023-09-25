FIGURES_FOLDER := figures
PDFS := \
$(filter-out $(wildcard $(FIGURES_FOLDER)/*-crop.pdf),$(wildcard $(FIGURES_FOLDER)/*.pdf)) \
$(filter-out $(wildcard $(FIGURES_FOLDER)/**/*-crop.pdf),$(wildcard $(FIGURES_FOLDER)/**/*.pdf))
CROPPED_PDFS := $(PDFS:.pdf=-crop.pdf)

all: main.pdf

%.pdf: %.tex Makefile $(CROPPED_PDFS)
	pdflatex -synctex=1 -interaction=nonstopmode $<
	-bibtex $*.aux
	pdflatex -synctex=1 -interaction=nonstopmode $<
	pdflatex -synctex=1 -interaction=nonstopmode $<

.PHONY: figures
figures: $(CROPPED_PDFS)

.PRECIOUS: $(CROPPED_PDFS)
%-crop.pdf: %.pdf Makefile
	pdfcrop $<

.PHONY: clean upgrade
clean:
	find . -maxdepth 1 \
		\( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
	           -name "*.log" -o -name "*.out" -o -name "*.pdf" -o \
		   -name "*.synctex.gz" \) | xargs $(RM)
	find $(FIGURES_FOLDER) -name "*-crop.pdf" | xargs $(RM)

YEAR := 2024

upgrade:
	curl -LO https://github.com/ICLR/Master-Template/raw/master/iclr${YEAR}.zip
	unzip -o iclr${YEAR}.zip iclr${YEAR}/iclr${YEAR}_conference.sty \
	                         iclr${YEAR}/iclr${YEAR}_conference.bst \
	                         iclr${YEAR}/math_commands.tex
	cp iclr${YEAR}/iclr${YEAR}_conference.sty iclr_conference.sty
	cp iclr${YEAR}/iclr${YEAR}_conference.bst iclr_conference.bst
	cp iclr${YEAR}/math_commands.tex math_commands.tex
	$(RM) -r iclr${YEAR}.zip iclr${YEAR}
