ALL: paco.tar.gz

doc: R/*.r
	R -e "library(devtools); document('.')"

cran/paco:
	mkdir -p cran/paco

test: cran/paco doc
	mkdir -p cran/paco
	cp -r * cran/paco 2>/dev/null; true
	rm -r cran/paco/{cran,tests}
	rm cran/paco/Makefile
	rm cran/paco/paco.tar.gz
	cd cran; R CMD check --as-cran paco

paco.tar.gz:
	rm $@ 2>/dev/null; true
	cd cran; tar -zcvf $@ paco
	mv cran/paco.tar.gz $@

clean:
	rm paco.tar.gz
	rm -r cran/paco
