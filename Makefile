all: gulp

gulp:
	gulp

install:
	luarocks install moonscript
	npm i -g gulp-cli
	npm i

compile:
	coffee -w -b -c ./ &
	moonc -w ./ &
	sleep infinity

moonscript:
	echo $1