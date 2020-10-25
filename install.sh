#!/bin/bash

NONE='\033[00m'
PURPLE='\033[01;35m'
RED='\033[0;31m'

# Main function that installs Homebrew packages and SWTOR
install () {
	sleep 1

	echo
	echo -e "${PURPLE}     Step 1: Create temporary downloads folder${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

	# Create temporary downloads folder for executables and icon
	echo -e "${PURPLE}     (1/1) Creating temporary downloads folder${NONE}"
	sleep 1
	mkdir ~/swtor_tmp

	echo
	echo -e "${PURPLE}     Step 2: Install Homebrew packages${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

	# Install Wget
	echo -e "${PURPLE}     (1/5) Installing wget${NONE}"
	brew install wget &&

	# Install Cask
	echo
	echo -e "${PURPLE}     (2/5) Installing cask${NONE}"
	brew install cask &&

	# Install XQuartz
	echo
	echo -e "${PURPLE}     (3/5) Installing XQuartz (Might take a while)${NONE}"
	brew cask install xquartz &&

	# Install Wine
	echo
	echo -e "${PURPLE}     (4/5) Installing Wine${NONE}"
	brew cask install --no-quarantine wine-stable &&

	# Install Winetricks
	echo
	echo -e "${PURPLE}     (5/5) Installing Winetricks${NONE}"
	brew install winetricks &&

	echo
	echo -e "${PURPLE}     Step 3: Create custom Wine prefix${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

	# Create a new Wine prefix titled "SWTOR On Mac"
	echo -e "${PURPLE}     (1/1) Creating "SWTOR On Mac" Wine prefix${NONE}"
	WINEARCH=win64 WINEPREFIX=~/"SWTOR On Mac" wine wineboot> /dev/null 2>&1 &&

	echo
	echo -e "${PURPLE}     Step 4: Install DLLs to prefix${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

	# Install vcrun2008
	echo -e "${PURPLE}     (1/3) Installing vcrun2008${NONE}"
	env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q vcrun2008> /dev/null 2>&1  &&

	# Install crypt32
	echo -e "${PURPLE}     (2/3) Installing crypt32${NONE}"
	env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q crypt32> /dev/null 2>&1  &&

	# Install d3dx9_36
	echo -e "${PURPLE}     (3/3) Installing d3dx9_36${NONE}"
	env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q d3dx9_36> /dev/null 2>&1  &&

	echo
	echo -e "${PURPLE}     Step 5: Change prefix settings${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

	# Set VRAM to 512
	echo -e "${PURPLE}     (1/2) Setting prefix VRAM to 512${NONE}"
	env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q videomemorysize=512> /dev/null 2>&1 &&

	# Switch Windows version to 10
	echo -e "${PURPLE}     (2/2) Switching Windows version to Windows 10${NONE}"
	env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q win10> /dev/null 2>&1 &&

	echo
	echo -e "${PURPLE}     Step 6: Download executables and icon${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

	# Download SWTOR_setup.exe, swtor_fix.exe and swtor_icon.icns
	cd ~/swtor_tmp/ || exit
	echo -e "${PURPLE}     (1/3) Downloading swtor_fix.exe from https://github.com/AgentRG/swtor_fix/${NONE}"
	wget https://github.com/AgentRG/swtor_fix/raw/master/swtor_fix.exe -q &&
	echo -e "${PURPLE}     (2/3) Downloading SWTOR_setup.exe from http://www.swtor.com/download${NONE}"
	wget -q -O SWTOR_setup.exe http://www.swtor.com/download -q &&
	echo -e "${PURPLE}     (3/3) Downloading swtor_logo.icns from https://github.com/AgentRG/swtor_on_mac"
	wget -q -O swtor_icon.icns https://github.com/AgentRG/swtor_on_mac/blob/master/swtor_logo.icns?raw=true
	cd ~/ || exit
	sleep 1

	echo
	echo -e "${PURPLE}     Step 7: Move executables and icon and move to prefix folder${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

	# Move "SWTOR_Setup.exe, swtor_fix.exe and swtor_icon.icns to Program Files (x86) folder"
	echo -e "${PURPLE}     (1/3) Moving swtor_fix.exe to prefix folder${NONE}"
	mv ~/swtor_tmp/swtor_fix.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
	echo -e "${PURPLE}     (2/3) Moving SWTOR_setup.exe to prefix folder${NONE}"
	mv ~/swtor_tmp/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
	echo -e "${PURPLE}     (3/3) Moving swtor_icon.icns to prefix folder${NONE}"
	mv ~/swtor_tmp/swtor_icon.icns ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
	sleep 1

	echo
	echo -e "${PURPLE}     Step 8: Delete temporary downloads folder${NONE}"
	echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

	# Delete temporary downloads folder
	echo -e "${PURPLE}     (1/1) Deleting temporary downloads folder ${NONE}"
	rm -r ~/swtor_tmp/
	sleep 1

	echo
	echo -e "${PURPLE}     SWTOR On Mac Installation Finished Successfully!${NONE}"

	# Launch SWTOR_Setup.exe
	sleep 2
	echo
	echo -e "${PURPLE}     Launching SWTOR_setup.exe...${NONE}"
	WINEPREFIX=~/"SWTOR On Mac" wine ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR_setup.exe > /dev/null 2>&1
}

echo
echo -e "${PURPLE}     AgentRG's SWTOR On Mac ${NONE}"

tools_version=$(xcode-select -p)
tools_installed="/Library/Developer/CommandLineTools"

# Check if Command Line Tools are installed followed by if Homebrew is installed
# If either isn't installed, the script will quit
if [ "$tools_version" = "$tools_installed" ]; then
        if [[ $(command -v brew) == "" ]]; then
                echo -e "${RED}     ERROR: Homebrew not installed. Exiting.${NONE}"
        else
                install
        fi
else
        echo -e "${RED}     ERROR: Command Line Tools not installed. Exiting.${NONE}"
fi
