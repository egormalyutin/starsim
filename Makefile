all: gulp

gulp:
	gulp

deps:
	npm i

cm:
	coffee -w -b -c ./ &
	moonw &
	sleep infinity