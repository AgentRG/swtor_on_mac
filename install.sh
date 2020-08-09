#!/bin/bash

# Install Wget and Cask
brew install wget cask &&

# Install XQuartz and Wine
brew cask install xquartz --no-quarantine wine-stable &&

# Install Winetricks
brew install winetricks &&

# Install vcrun2008, crypt32, d3dx9_36. Also set VRAM to 1024 and set Windows version to 10
winetricks -q vcrun2008 crypt32 d3dx9_36 videomemorysize=1024 win10 &&

# Pull the swtor launcher and swtor_fix.exe (required to run SWTOR) from repository to home directory
wget https://github.com/AgentRG/swtor_fix/raw/master/swtor_fix.exe && wget -O SWTOR_setup.exe http://www.swtor.com/download &&

# Move swtor_fix.exe to Program Files (x86) folder
mv ~/swtor_fix.exe ~/.wine/drive_c/Program\ Files\ \(x86\)/ && mv ~/SWTOR_setup.exe ~/.wine/drive_c/Program\ Files\ \(x86\)/ &&

#Launch swtor setup launcher
wine ~/.wine/drive_c/Program\ Files\ \(x86\)/SWTOR_setup.exe
