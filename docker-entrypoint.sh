#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- cells "$@"
fi

if [ "$1" == "cells" ]; then
	# This file acts as a flag to check if we can start Cells or if we want to perform the non-interactive install.
	FILE="/home/pydio/.config/pydio/cells/pydio.json"
	if [ ! -f "$FILE" ] ; then 
	
			# No TLS
			cells install --bind $CELLS_BIND --external $CELLS_EXTERNAL --no_ssl "$@"
	
	else
		"$@"
	fi

else
	exec "$@"
fi
