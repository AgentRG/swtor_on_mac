#!/bin/bash

NONE='\033[00m'
PURPLE='\033[01;35m'
RED='\033[0;31m'
EARLIEST_POSSIBLE_OS_TO_RUN_IN=10.13
LAST_POSSIBLE_OS_TO_RUN_IN=10.14
CURRENT_VERSION=$(sw_vers -productVersion | awk '{print $1}' | sed "s:.[[:digit:]]*.$::g")
TOOLS_VERSION=$(xcode-select -p)
TOOLS_INSTALLED="/Library/Developer/CommandLineTools"
XCODE_CHECK=$(ls /Applications/Xcode.app)
XCODE_INSTALLED="Contents"

create_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Creating temporary downloads folder\n${NONE}"
  mkdir ~/swtor_tmp
}

install_package_wget() {
  echo -e "${PURPLE}\t(1/4) Installing wget${NONE}"
  brew install wget
}

tap_into_gcenx() {
  echo -e "${PURPLE}\t(2/4) Tapping into Gcenx custom Wine Builds (https://github.com/Gcenx/macOS_Wine_builds)"
  brew tap gcenx/wine
}

install_package_gcenx_wine() {
  echo -e "${PURPLE}\t(3/4) Installing TEST Gcenx custom Wine${NONE}"
  brew install --cask --no-quarantine gcenx-wine-staging
}

install_package_winetricks() {
  echo -e "${PURPLE}\t(4/4) Installing Winetricks\n${NONE}"
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
  echo -e "${PURPLE}\t(1/2) Setting prefix VRAM to 1024${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q videomemorysize=1024
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

download_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(3/3) Downloading SWTOR.zip from https://github.com/AgentRG/swtor_on_mac/${NONE}"
  wget https://github.com/AgentRG/swtor_on_mac/raw/master/SWTOR.zip
}

move_swtor_fix() {
  echo -e "${PURPLE}\t(1/3) Moving swtor_fix.exe to prefix folder${NONE}"
  mv ~/swtor_tmp/swtor_fix.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

move_swtor_setup() {
  echo -e "${PURPLE}\t(2/3) Moving SWTOR_setup.exe to prefix folder${NONE}"
  mv ~/swtor_tmp/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

move_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(3/3) Moving SWTOR.zip to prefix folder\n${NONE}"
  mv ~/swtor_tmp/SWTOR.zip ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
}

delete_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Deleting temporary downloads folder\n${NONE}"
  rm -r ~/swtor_tmp/
}

unzip_swtor_app() {
  echo -e "${PURPLE}\t(1/2) Unzip SWTOR.zip\n${NONE}"
  unzip ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR.zip
}

move_swtor_app_to_desktop() {
  echo -e "${PURPLE}\t(2/2) Move SWTOR.app to Desktop\n${NONE}"
  mv ~/SWTOR.app ~/Desktop/
}

launch_swtor() {
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
  tap_into_gcenx
  install_package_gcenx_wine
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

  echo -e "${PURPLE}\tStep 6: Download SWTOR executable${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd ~/swtor_tmp/ || exit
  download_swtor_fix
  download_swtor
  download_swtor_shortcut_zip
  cd ~/ || exit

  echo -e "${PURPLE}\tStep 7: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  move_swtor_fix
  move_swtor_setup
  move_swtor_shortcut_zip

  echo -e "${PURPLE}\tStep 8: Delete temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  delete_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 9: Unzip SWTOR.zip and move application to Desktop${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  unzip_swtor_app
  move_swtor_app_to_desktop

  echo -e "${PURPLE}\tSWTOR On Mac Installation Finished Successfully!${NONE}"

  launch_swtor
}

check_if_not_catalina_or_later() {
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]]; then
    echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra or Mojave. Exiting${NONE}"
    exit
  fi
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
    echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra or Mojave. Exiting${NONE}"
    exit
  fi
}

check_if_not_high_sierra_or_earlier() {
    if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -lt $(echo "${EARLIEST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]]; then
      echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra or Mojave. Exiting${NONE}"
      exit
    fi
    if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -lt $(echo "${EARLIEST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
      echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra or Mojave. Exiting${NONE}"
      exit
    fi
}

echo -e "${PURPLE}\tAgentRG's SWTOR On Mac\n${NONE}"

check_if_not_high_sierra_or_earlier
check_if_not_catalina_or_later

# Check if Command Line Tools are installed followed by if Homebrew is installed
# If either isn't installed, the script will quit
if [ "$TOOLS_VERSION" = "$TOOLS_INSTALLED" ] || [ "$XCODE_CHECK" = "$XCODE_INSTALLED" ]; then
  if [[ $(command -v brew) == "" ]]; then
    echo -e "${RED}\tERROR: Homebrew not installed. Exiting.${NONE}"
  else
    install
  fi
else
  echo -e "${RED}\tERROR: Command Line Tools not installed. Exiting.${NONE}"
fi