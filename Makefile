all: gulp

gulp:
	gulp

install:
	luarocks install moonscript
	npm i -g gulp-cli
	npm i

compile:
	coffee -w -b -c ./ &
	./moonscript &
	sleep infinity