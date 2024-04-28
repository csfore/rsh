#!/bin/bash

preexec() {
	# In true autotools fashion
	if [ "x$BASH_COMMAND" = "xgenfun_set_win_title" ]; then
		return
	fi

	# Cleaning the command of its sins
	CLEAN_CMD=$(echo $BASH_COMMAND | awk '{ print $1 }')
	
	# Making sure it exists
	qfile $CLEAN_CMD > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		return
	fi
	
	# Gettings just the package
	FILE=$(qfile $CLEAN_CMD | grep "/usr/bin" | awk -F ':' '{ print $1 }')
	
	# Generating a hash for unique and robustness
	HASH=$(echo "$EPOCREALTTIME $FILE" | sha256sum | awk '{ print $1 }')

	# Setting our root directory for portage
	ROOT="/tmp/rsh/$HASH/$FILE"

	# Emerge!
	emerge -1 --root="$ROOT" $FILE
}

trap 'preexec' DEBUG
