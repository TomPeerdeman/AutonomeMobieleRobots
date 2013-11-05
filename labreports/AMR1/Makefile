BIB = bibtex
TEX = pdflatex

FILE = AMR1

$(FILE).pdf: $(FILE).bbl
	$(TEX) $(FILE)
	$(TEX) $(FILE)

$(FILE).bbl: $(FILE).bib $(FILE).aux
	$(BIB) $(FILE).aux
	
$(FILE).aux:
	$(TEX) $(FILE)
	
.PHONY: clean bib pdf cleanbib

clean:
	rm -f $(FILE).pdf *.aux *.bbl *.blg *.out *.log
	
bib: 
	$(FILE).bbl
	
pdf:
	$(TEX) $(FILE)
	
cleanbib:
	rm -f *.bbl *.blg
