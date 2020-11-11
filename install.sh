#!/bin/bash

NONE='\033[00m'
PURPLE='\033[01;35m'
RED='\033[0;31m'

create_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Creating temporary downloads folder\n${NONE}"
  mkdir ~/swtor_tmp
}

install_package_wget() {
  echo -e "${PURPLE}\t(1/5) Installing wget${NONE}"
  brew install wget
}

install_package_cask() {
  echo -e "${PURPLE}\t(2/5) Installing cask${NONE}"
  brew install cask
}

install_package_xquartz() {
  echo -e "${PURPLE}\t(3/5) Installing XQuartz (Might take a while)${NONE}"
  brew cask install xquartz
}

install_package_wine() {
  echo -e "${PURPLE}\t(4/5) Installing Wine${NONE}"
  brew cask install --no-quarantine wine-stable
}

install_package_winetricks() {
  echo -e "${PURPLE}\t(5/5) Installing Winetricks\n${NONE}"
  brew install winetricks
}

create_swtor_prefix() {
  echo -e "${PURPLE}\t(1/1) Creating "SWTOR On Mac" Wine prefix\n${NONE}"
  WINEARCH=win64 WINEPREFIX=~/"SWTOR On Mac" wine wineboot
}

install_dll_vcrun2008() {
  echo -e "${PURPLE}\t(1/3) Installing vcrun2008${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q vcrun2008
}

install_dll_crypt32() {
  echo -e "${PURPLE}\t(2/3) Installing crypt32${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q crypt32
}

install_dll_d3dx9_36() {
  echo -e "${PURPLE}\t(3/3) Installing d3dx9_36\n${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q d3dx9_36
}

set_vram() {
  echo -e "${PURPLE}\t(1/2) Setting prefix VRAM to 512${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q videomemorysize=512
}

switch_windows_version() {
  echo -e "${PURPLE}\t(2/2) Switching Windows version to Windows 10\n${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q win10
}

download_swtor_fix() {
  echo -e "${PURPLE}\t(1/3) Downloading swtor_fix.exe from https://github.com/AgentRG/swtor_fix/${NONE}"
  wget https://github.com/AgentRG/swtor_fix/raw/master/swtor_fix.exe
}

download_swtor() {
  echo -e "${PURPLE}\t(2/3) Downloading SWTOR_setup.exe from http://www.swtor.com/download${NONE}"
  wget -O SWTOR_setup.exe http://www.swtor.com/download
}

download_swtor_icon() {
  echo -e "${PURPLE}\t(3/3) Downloading swtor_logo.icns from https://github.com/AgentRG/swtor_on_mac\n"
  wget -O swtor_icon.icns https://github.com/AgentRG/swtor_on_mac/blob/master/swtor_logo.icns?raw=true
}

move_swtor_fix() {
  echo -e "${PURPLE}\t(1/3) Moving swtor_fix.exe to prefix folder${NONE}"
  mv ~/swtor_tmp/swtor_fix.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

move_swtor_setup() {
  echo -e "${PURPLE}\t(2/3) Moving SWTOR_setup.exe to prefix folder${NONE}"
  mv ~/swtor_tmp/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

move_swtor_icon() {
  echo -e "${PURPLE}\t(3/3) Moving swtor_icon.icns to prefix folder\n${NONE}"
  mv ~/swtor_tmp/swtor_icon.icns ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

delete_temporary_downloads_folder () {
  echo -e "${PURPLE}\t(1/1) Deleting temporary downloads folder\n${NONE}"
  rm -r ~/swtor_tmp/
}

launch_swtor () {
  echo -e "${PURPLE}\tLaunching SWTOR_setup.exe...${NONE}"
  WINEPREFIX=~/"SWTOR On Mac" wine ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR_setup.exe >/dev/null 2>&1
}

# Main function that installs Homebrew packages and SWTOR
install() {

  echo -e "${PURPLE}\tStep 1: Create temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  create_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 2: Install Homebrew packages${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_package_wget
  install_package_cask
  install_package_xquartz
  install_package_wine
  install_package_winetricks

  echo -e "${PURPLE}\tStep 3: Create custom Wine prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  create_swtor_prefix

  echo -e "${PURPLE}\tStep 4: Install DLLs to prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_dll_vcrun2008
  install_dll_crypt32
  install_dll_d3dx9_36

  echo -e "${PURPLE}\tStep 5: Change prefix settings${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  set_vram
  switch_windows_version

  echo -e "${PURPLE}\tStep 6: Download executables and icon${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd ~/swtor_tmp/ || exit
  download_swtor_fix
  download_swtor
  download_swtor_icon
  cd ~/ || exit

  echo -e "${PURPLE}\tStep 7: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  move_swtor_fix
  move_swtor_setup
  move_swtor_icon

  echo -e "${PURPLE}\tStep 8: Delete temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  delete_temporary_downloads_folder

  echo -e "${PURPLE}\tSWTOR On Mac Installation Finished Successfully!${NONE}"

  launch_swtor
}

check_if_not_catalina_or_later () {
  if [[ $(sw_vers -productVersion | awk '{print $1}' | sed "s:.[[:digit:]]*.$::g" | sed -e 's/\.//g') -ge 1015 ]]; then
    echo -e "${RED}\tERROR: SWTOR will not work on machines with macOS 10.15 or later. Existing"
    exit
  fi
}


echo -e "${PURPLE}\tAgentRG's SWTOR On Mac\n${NONE}"

check_if_not_catalina_or_later

tools_version=$(xcode-select -p)
tools_installed="/Library/Developer/CommandLineTools"
xcode_check=$(ls /Applications/Xcode.app)
xcode_installed="Contents"

# Check if Command Line Tools are installed followed by if Homebrew is installed
# If either isn't installed, the script will quit
if [ "$tools_version" = "$tools_installed" ] || [ "$xcode_check" = "$xcode_installed" ]; then
  if [[ $(command -v brew) == "" ]]; then
    echo -e "${RED}\tERROR: Homebrew not installed. Exiting.${NONE}"
  else
    install
  fi
else
  echo -e "${RED}\tERROR: Command Line Tools not installed. Exiting.${NONE}"
fi
