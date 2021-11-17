#!/bin/bash

export PATH="/usr/local/bin:$PATH"
export LAST_POSSIBLE_OS_TO_RUN_IN=1014
CURRENT_VERSION=$(sw_vers -productVersion | awk '{print $1}' | sed "s:.[[:digit:]]*.$::g")
export CURRENT_USER

if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -eq 0 ]]; then
	CURRENT_VERSION_00=$(echo "${CURRENT_VERSION}" | cut -d"." -f1)00
	export CURRENT_VERSION_00
	export CURRENT_VERSION=$CURRENT_VERSION_00
else
	CURRENT_VERSION=$(echo "${CURRENT_VERSION}" | cut -d"." -f1)$(echo "${CURRENT_VERSION}" | cut -d"." -f2)
	export CURRENT_USER
fi

# Oddness for reassigned PATH_TO_SWTOR_LAUNCHER comes from custom/express installation
if [[ $CURRENT_VERSION -gt $LAST_POSSIBLE_OS_TO_RUN_IN ]]; then
	PREFIX_LOCATION=$(dirname "$(find ~/ -path \*drive_c/Program\ Files/Electronic\ Arts -print -quit 2>/dev/null| tail -1 | grep -o '.*/drive_c')")
	PATH_TO_SWTOR_LAUNCHER="/drive_c/Program Files/Electronic Arts/BioWare/Star Wars - The Old Republic/launcher.exe"
	cd "$PREFIX_LOCATION$PATH_TO_SWTOR_LAUNCHER" || PATH_TO_SWTOR_LAUNCHER="/drive_c/Program Files/Electronic Arts/BioWare/Star Wars-The Old Republic/launcher.exe"
	WINEPREFIX=$PREFIX_LOCATION wine32on64 "$PREFIX_LOCATION$PATH_TO_SWTOR_LAUNCHER"
else
	PREFIX_LOCATION=$(dirname "$(find ~/ -path \*drive_c/Program\ Files\ \(x86\)/Electronic\ Arts -print -quit 2>/dev/null| tail -1 | grep -o '.*/drive_c')")
	PATH_TO_SWTOR_LAUNCHER="/drive_c/Program Files (x86)/Electronic Arts/BioWare/Star Wars - The Old Republic/launcher.exe"
	cd "$PREFIX_LOCATION$PATH_TO_SWTOR_LAUNCHER" || PATH_TO_SWTOR_LAUNCHER="/drive_c/Program Files/Electronic Arts/BioWare/Star Wars-The Old Republic/launcher.exe"
	WINEPREFIX=$PREFIX_LOCATION wine "$PREFIX_LOCATION$PATH_TO_SWTOR_LAUNCHER"
fi