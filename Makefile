all: gulp

gulp:
	gulp

dev:
	luarocks install moonscript
	npm i -g gulp-cli
	npm i

cm:
	coffee -w -b -c ./ &
	./moonscript &
	sleep infinity