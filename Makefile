all: gulp

gulp:
	gulp

deps:
	npm i -g gulp
	npm i

cm:
	coffee -w -b -c ./ &
	moonw &
	sleep infinity