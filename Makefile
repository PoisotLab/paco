all: paco.tar.gz

doc:
	Rscript -e "library(methods);library(devtools);library(roxygen2);roxygenise('.')"

paco.tar.gz: doc
	tar -z -c -v -f paco.tar.gz . --exclude-vcs --exclude "*gz" --exclude "Makefile"
