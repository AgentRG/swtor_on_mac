#!/usr/bin/env arch -x86_64 bash

set -e

NONE='\033[00m'
PURPLE='\033[01;35m'
RED='\033[0;31m'
MACOS_HIGH_SIERRA=1013
MACOS_CATALINA=1015
CURRENT_VERSION=$(sw_vers -productVersion | awk '{print $1}' | sed "s:.[[:digit:]]*.$::g")
TOOLS_VERSION=$(xcode-select -p)
TOOLS_INSTALLED="/Library/Developer/CommandLineTools"
XCODE_CHECK=$(ls /Applications/Xcode.app) || : # set -e can cause the script to die here, so added || : to skip fail
XCODE_INSTALLED="Contents"
CURRENT_USER=$(whoami)
SWTOR_CUSTOM_SHORTCUT_LINK=https://github.com/AgentRG/swtor_on_mac/raw/master/SWTOR.zip
SWTOR_DOWNLOAD=http://www.swtor.com/download

if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2 | wc -c) -eq 2 ]]; then
  CURRENT_VERSION_COMBINED=$(echo "${CURRENT_VERSION}" | cut -d"." -f1)0$(echo "${CURRENT_VERSION}" | cut -d"." -f2)
  export CURRENT_VERSION_COMBINED
else
	CURRENT_VERSION_COMBINED=$(echo "${CURRENT_VERSION}" | cut -d"." -f1)$(echo "${CURRENT_VERSION}" | cut -d"." -f2)
	export CURRENT_VERSION_COMBINED
fi

create_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Creating temporary downloads folder\n${NONE}"
  mkdir /Users/"$CURRENT_USER"/swtor_tmp || :
}

check_if_wine_installed() {
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
    if [[ $(wine32on64 --version) != "wine-6.0" ]]; then
      echo -e "${RED}\tERROR: Crossover Wine didn't get installed. Please check for errors in the output. Exiting.${NONE}"
      exit
    fi
  fi
}

create_swtor_prefix() {
  echo -e "${PURPLE}\t(1/1) Creating "SWTOR On Mac" Wine prefix\n${NONE}"
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
    WINEARCH=win32 WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" wine32on64 wineboot
  else
    WINEARCH=win64 WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" wine wineboot
  fi
}

install_dll_vcrun2008() {
  echo -e "${PURPLE}\t(1/3) Installing vcrun2008${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q vcrun2008
}

install_dll_crypt32() {
  echo -e "${PURPLE}\t(2/3) Installing crypt32${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q crypt32
}

install_dll_d3dx9_36() {
  echo -e "${PURPLE}\t(3/3) Installing d3dx9_36\n${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q d3dx9_36
}

set_vram() {
  echo -e "${PURPLE}\t(1/3) Setting prefix VRAM to 1024${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q videomemorysize=1024
}

switch_windows_version() {
  echo -e "${PURPLE}\t(2/3) Switching Windows version to Windows 10${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q win10
}

switch_all_dlls_to_builtin() {
  echo -e "${PURPLE}\t(3/3) Change all prefix DLLs to be builtin\n${NONE}"
  env WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" sh winetricks -q alldlls=builtin
}

download_swtor() {
  echo -e "${PURPLE}\t(1/2) Downloading SWTOR_setup.exe from http://www.swtor.com/download${NONE}"
  wget -O SWTOR_setup.exe $SWTOR_DOWNLOAD
}

download_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(2/2) Downloading SWTOR.zip from https://github.com/AgentRG/swtor_on_mac/${NONE}"
  wget $SWTOR_CUSTOM_SHORTCUT_LINK
}

move_swtor_setup() {
  echo -e "${PURPLE}\t(1/2) Moving SWTOR_setup.exe to prefix folder${NONE}"
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
    mv "/Users/$CURRENT_USER/swtor_tmp/SWTOR_setup.exe" "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files/"
  else
    mv "/Users/$CURRENT_USER/swtor_tmp/SWTOR_setup.exe" "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files (x86)/"
  fi
}

move_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(2/2) Moving SWTOR.zip to prefix folder\n${NONE}"
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
    mv "/Users/$CURRENT_USER/swtor_tmp/SWTOR.zip" "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files/"
  else
    mv "/Users/$CURRENT_USER/swtor_tmp/SWTOR.zip" "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files (x86)/"
  fi
}

delete_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Deleting temporary downloads folder\n${NONE}"
  rm -r /Users/"$CURRENT_USER"/swtor_tmp/
}

unzip_swtor_app() {
  echo -e "${PURPLE}\t(1/2) Unzip SWTOR.zip\n${NONE}"
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
      unzip "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files/SWTOR.zip"
  else
      unzip "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files (x86)/SWTOR.zip"
  fi
}

move_swtor_app_to_desktop() {
  echo -e "${PURPLE}\t(2/2) Move SWTOR.app to Desktop\n${NONE}"
  mv "/Users/$CURRENT_USER/SWTOR.app" "/Users/$CURRENT_USER/Desktop/"
}

launch_swtor() {
  echo -e "${PURPLE}\tLaunching SWTOR_setup.exe...${NONE}"
  if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
    WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" wine32on64 "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files/SWTOR_setup.exe" >/dev/null 2>&1
  else
    WINEPREFIX="/Users/$CURRENT_USER/SWTOR On Mac" wine "/Users/$CURRENT_USER/SWTOR On Mac/drive_c/Program Files (x86)/SWTOR_setup.exe" >/dev/null 2>&1
    fi
}

# Main function that installs Homebrew packages and SWTOR for macOS's before Catalina
install_pre_catalina() {

  check_if_wine_installed

  echo -e "${PURPLE}\tStep 1: Create temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  create_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 2: Create custom Wine prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  create_swtor_prefix

  echo -e "${PURPLE}\tStep 3: Install DLLs to prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_dll_vcrun2008
  install_dll_crypt32
  install_dll_d3dx9_36

  echo -e "${PURPLE}\tStep 4: Change prefix settings${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  set_vram
  switch_windows_version
  switch_all_dlls_to_builtin

  echo -e "${PURPLE}\tStep 5: Download SWTOR executable${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd "/Users/$CURRENT_USER/swtor_tmp/" || exit
  download_swtor
  download_swtor_shortcut_zip
  cd "/Users/$CURRENT_USER/" || exit

  echo -e "${PURPLE}\tStep 6: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  move_swtor_setup
  move_swtor_shortcut_zip

  echo -e "${PURPLE}\tStep 7: Delete temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  delete_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 8: Unzip SWTOR.zip and move application to Desktop${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  unzip_swtor_app
  move_swtor_app_to_desktop

  echo -e "${PURPLE}\tSWTOR On Mac Installation Finished Successfully!${NONE}"

  launch_swtor
}

# Main function that installs Homebrew packages and SWTOR for macOS's after Catalina
install_post_catalina() {

  check_if_wine_installed

  echo -e "${PURPLE}\tStep 1: Create temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  create_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 2: Create custom Wine prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  create_swtor_prefix

  echo -e "${PURPLE}\tStep 3: Install DLLs to prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  export WINE=wine32on64 # required to fool winetricks into using wine32on64
  install_dll_vcrun2008
  install_dll_crypt32
  install_dll_d3dx9_36

  echo -e "${PURPLE}\tStep 4: Change prefix settings${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  set_vram
  switch_windows_version
  switch_all_dlls_to_builtin

  echo -e "${PURPLE}\tStep 5: Download SWTOR executable${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd "/Users/$CURRENT_USER/swtor_tmp/" || exit
  download_swtor
  download_swtor_shortcut_zip
  cd "/Users/$CURRENT_USER/" || exit

  echo -e "${PURPLE}\tStep 6: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  move_swtor_setup
  move_swtor_shortcut_zip

  echo -e "${PURPLE}\tStep 7: Delete temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  delete_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 8: Unzip SWTOR.zip and move application to Desktop${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  unzip_swtor_app
  move_swtor_app_to_desktop

  echo -e "${PURPLE}\tSWTOR On Mac Installation Finished Successfully!${NONE}"

  launch_swtor
}

check_if_not_high_sierra_or_earlier() {
    if [[ $CURRENT_VERSION_COMBINED -lt $MACOS_HIGH_SIERRA ]]; then
      echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra (10.13) or later. The macOS of this machine is $CURRENT_VERSION. Exiting${NONE}"
      exit
    fi
}

echo -e "${PURPLE}\tAgentRG's SWTOR On Mac (Just SWTOR)\n${NONE}"

check_if_not_high_sierra_or_earlier

# Check if Command Line Tools are installed followed by if Homebrew is installed
# If either isn't installed, the script will quit
if [ "$TOOLS_VERSION" = "$TOOLS_INSTALLED" ] || [ "$XCODE_CHECK" = "$XCODE_INSTALLED" ]; then
  if [[ $(command -v brew) == "" ]]; then
    echo -e "${RED}\tERROR: Homebrew not installed. Exiting.${NONE}"
  else
    if [[ $CURRENT_VERSION_COMBINED -ge $MACOS_CATALINA ]]; then
      install_post_catalina
    else
      install_pre_catalina
    fi
  fi
else
  echo -e "${RED}\tERROR: Command Line Tools not installed. Exiting.${NONE}"
fi