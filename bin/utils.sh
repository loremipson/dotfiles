warn() {
	echo "$1" >&2
}

die() {
	warn "$1"
	exit 1
}