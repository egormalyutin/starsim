all: gulp

gulp:
	gulp

cm:
	coffee -w -b -c ./ &
	moonw &
	sleep infinity