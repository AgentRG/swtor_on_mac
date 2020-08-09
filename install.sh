#!/bin/bash

NONE='\033[00m'
PURPLE='\033[01;35m'

echo  
echo -e "${PURPLE}     AgentRG's SWTOR On Mac${NONE}" 

sleep 1
echo
echo -e "${PURPLE}     Step 1: Install Homebrew packages${NONE}"
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
echo -e "${PURPLE}     (3/5) Installing XQuartz${NONE}"
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
echo -e "${PURPLE}     Step 2: Create custom Wine prefix${NONE}"
echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

# Create a new Wine prefix titled "SWTOR On Mac"
echo -e "${PURPLE}     (1/1) Creating "SWTOR On Mac" Wine prefix${NONE}"
WINEARCH=win64 WINEPREFIX=~/"SWTOR On Mac" wine wineboot> /dev/null 2>&1 &&

echo
echo -e "${PURPLE}     Step 3: Install DLLs to prefix${NONE}"
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
echo -e "${PURPLE}     Step 4: Change prefix settings${NONE}"
echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

# Set VRAM to 1024
echo -e "${PURPLE}     (1/2) Setting prefix VRAM to 1024${NONE}"
env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q videomemorysize=1024> /dev/null 2>&1 &&

# Switch Windows version to 10
echo -e "${PURPLE}     (2/2) Switching Windows version to 10${NONE}"
env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q win10> /dev/null 2>&1 &&

echo
echo -e "${PURPLE}     Step 5: Download executables and move to prefix folder${NONE}"
echo -e "${PURPLE}     ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

# Download SWTOR_setup.exe and swtor_fix.exe
echo -e "${PURPLE}     (1/3) Downloading swtor_fix.exe from https://github.com/AgentRG/swtor_fix/${NONE}"
wget https://github.com/AgentRG/swtor_fix/raw/master/swtor_fix.exe -q &&
echo -e "${PURPLE}     (2/3) Downloading SWTOR_setup.exe from http://www.swtor.com/download${NONE}"
wget -q -O SWTOR_setup.exe http://www.swtor.com/download -q &&

# Move SWTOR_Setup.exe and swtor_fix.exe to Program Files (x86) folder
echo -e "${PURPLE}     (3/3) Moving executables to prefix folder${NONE}"
mv ~/swtor_fix.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/ && mv ~/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/ &&
echo
echo -e "${PURPLE}     SWTOR On Mac Installation Finished Successfully!${NONE}"

#Launch SWTOR_Setup.exe
sleep 2
echo
echo -e "${PURPLE}     Launching SWTOR_setup.exe...${NONE}"
WINEPREFIX=~/"SWTOR On Mac" wine ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR_setup.exe > /dev/null 2>&1
