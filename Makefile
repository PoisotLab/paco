doc:
	R -e "library(devtools); document('.')"

cran/paco:
	mkdir -p cran/paco

test: cran/paco doc
	mkdir -p cran/paco
	cp -r * cran/paco 2>/dev/null; true
	rm -r cran/paco/{cran,inst,tests}
	rm cran/paco/Makefile
	cd cran; R CMD check paco

paco.tar.gz:
	cd cran; tar -zcvf $@ paco
	mv cran/paco.tar.gz $@
