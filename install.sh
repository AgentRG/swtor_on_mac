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
CORES_AVAILABLE=$(sysctl -n hw.physicalcpu)

create_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Creating temporary downloads folder\n${NONE}"
  mkdir ~/swtor_tmp
}

# Pre-Catalina Package Management

install_package_wget() {
  echo -e "${PURPLE}\t(1/4) Installing wget${NONE}"
  brew install wget
}

tap_into_agentrg_brew() {
  echo -e "${PURPLE}\t(2/4) Tap into AgentRG/homebrew-wine${NONE}"
  brew tap agentrg/homebrew-wine
}

install_package_wine_stable() {
  echo -e "${PURPLE}\t(3/4) Installing latest Wine version${NONE}"
  brew install --cask --no-quarantine agentrg-wine-stable
}

install_package_winetricks() {
  echo -e "${PURPLE}\t(4/4) Installing Winetricks\n${NONE}"
  brew install winetricks
}

# ---

# Post-Catalina Package Management

install_package_wget_catalina() {
  echo -e "${PURPLE}\t(1/10) Installing wget${NONE}"
  brew install wget
}

install_package_winetricks_catalina() {
  echo -e "${PURPLE}\t(2/10) Installing Winetricks\n${NONE}"
  brew install winetricks
}

install_package_cmake() {
  echo -e "${PURPLE}\t(3/10) Installing CMake\n${NONE}"
  brew install cmake
}

install_package_gcc() {
  echo -e "${PURPLE}\t(4/10) Installing GCC\n${NONE}"
  brew install gcc
}

install_package_bison() {
  echo -e "${PURPLE}\t(5/10) Installing Bison\n${NONE}"
  brew install bison
  export PATH="$(brew --prefix bison)/bin:$PATH"
}

install_package_xquartz() {
  echo -e "${PURPLE}\t(6/10) Installing XQuartz\n${NONE}"
  brew install --cask xquartz
}

install_package_flex() {
  echo -e "${PURPLE}\t(7/10) Installing Flex\n${NONE}"
  brew install flex
}

install_package_mingw_w64() {
  echo -e "${PURPLE}\t(8/10) Installing Mingw-w64\n${NONE}"
  brew install mingw-w64
}

install_package_pkg_config() {
  echo -e "${PURPLE}\t(9/10) Installing pkg-config\n${NONE}"
  brew install pkg-config
}

install_package_freetype() {
  echo -e "${PURPLE}\t(10/10) Installing FreeType\n${NONE}"
  brew install freetype
}

# ---

download_crossover_21_patched() {
  echo -e "${PURPLE}\t(1/5) Downloading patched CrossOver 21 from https://github.com/AgentRG/swtor_on_mac${NONE}"
  wget https://github.com/AgentRG/swtor_on_mac/releases/download/6.0-crossover/src-crossover-wine-clang-0.0.1.tar.bz2
}

unpack_crossover_21_tar() {
  echo -e "${PURPLE}\t(2/5) Unpacking and deleting tar${NONE}"
  tar -jxvf src-crossover-wine-clang-0.0.1.tar.bz2 && rm -f src-crossover-wine-clang-0.0.1.tar.bz2
  cd ~/swtor_tmp/src-crossover-wine-clang-0.0.1/ || exit
}

compile_llvm() {
  cd clang/llvm && mkdir build && cd build && cmake ../ && make -j"$CORES_AVAILABLE" && cd bin && export PATH="$(pwd):$PATH" && cd ../../../..
}

compile_clang() {
  cd clang/clang && mkdir build && cd build && cmake ../ && make -j"$CORES_AVAILABLE" && cd bin && export PATH="$(pwd):$PATH" && cd ../../../..
}

compile_wine() {
  wine && export PATH="$(pwd):$PATH" && export MACOSX_DEPLOYMENT_TARGET=10.14 && CC="clang" CXX="clang++" MACOSX_DEPLOYMENT_TARGET=10.14 ./configure --enable-win32on64 -disable-winedbg --without-x --disable-tests --disable-mscms && make -j"$CORES_AVAILABLE" && sudo make install-lib
  export WINE=wine32on64
}

create_swtor_prefix() {
  echo -e "${PURPLE}\t(1/1) Creating "SWTOR On Mac" Wine prefix\n${NONE}"
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
    WINEARCH=win32 WINEPREFIX=~/"SWTOR On Mac" wine32on64 wineboot
  else
    WINEARCH=win64 WINEPREFIX=~/"SWTOR On Mac" wine wineboot
  fi
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
  echo -e "${PURPLE}\t(1/3) Setting prefix VRAM to 1024${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q videomemorysize=1024
}

switch_windows_version() {
  echo -e "${PURPLE}\t(2/3) Switching Windows version to Windows 10${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q win10
}

switch_all_dlls_to_builtin() {
  echo -e "${PURPLE}\t(3/3) Change all prefix DLLs to be builtin\n${NONE}"
  env WINEPREFIX=~/"SWTOR On Mac" sh winetricks -q alldlls=builtin
}

download_swtor() {
  echo -e "${PURPLE}\t(1/2) Downloading SWTOR_setup.exe from http://www.swtor.com/download${NONE}"
  wget -O SWTOR_setup.exe http://www.swtor.com/download
}

download_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(2/2) Downloading SWTOR.zip from https://github.com/AgentRG/swtor_on_mac/${NONE}"
  wget https://github.com/AgentRG/swtor_on_mac/raw/master/SWTOR.zip
}

move_swtor_setup() {
  echo -e "${PURPLE}\t(1/2) Moving SWTOR_setup.exe to prefix folder${NONE}"
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
    mv ~/swtor_tmp/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files/
  else
    mv ~/swtor_tmp/SWTOR_setup.exe ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
  fi
}

move_swtor_shortcut_zip() {
  echo -e "${PURPLE}\t(2/2) Moving SWTOR.zip to prefix folder\n${NONE}"
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
    mv ~/swtor_tmp/SWTOR.zip ~/SWTOR\ On\ Mac/drive_c/Program\ Files/
  else
    mv ~/swtor_tmp/SWTOR.zip ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/
  fi
}

delete_temporary_downloads_folder() {
  echo -e "${PURPLE}\t(1/1) Deleting temporary downloads folder\n${NONE}"
  rm -r ~/swtor_tmp/
}

unzip_swtor_app() {
  echo -e "${PURPLE}\t(1/2) Unzip SWTOR.zip\n${NONE}"
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
      unzip ~/SWTOR\ On\ Mac/drive_c/Program\ Files/SWTOR.zip
  else
      unzip ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR.zip
  fi
}

move_swtor_app_to_desktop() {
  echo -e "${PURPLE}\t(2/2) Move SWTOR.app to Desktop\n${NONE}"
  mv ~/SWTOR.app ~/Desktop/
}

launch_swtor() {
  echo -e "${PURPLE}\tLaunching SWTOR_setup.exe...${NONE}"
  if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
    WINEPREFIX=~/"SWTOR On Mac" wine32on64 ~/SWTOR\ On\ Mac/drive_c/Program\ Files/SWTOR_setup.exe >/dev/null 2>&1
  else
    WINEPREFIX=~/"SWTOR On Mac" wine ~/SWTOR\ On\ Mac/drive_c/Program\ Files\ \(x86\)/SWTOR_setup.exe >/dev/null 2>&1
    fi
}

# Main function that installs Homebrew packages and SWTOR for macOS's before Catalina
install_pre_catalina() {

  echo -e "${PURPLE}\tStep 1: Create temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  create_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 2: Install Homebrew packages${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_package_wget
  install_package_wine_stable
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
  switch_all_dlls_to_builtin

  echo -e "${PURPLE}\tStep 6: Download SWTOR executable${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd ~/swtor_tmp/ || exit
  download_swtor
  download_swtor_shortcut_zip
  cd ~/ || exit

  echo -e "${PURPLE}\tStep 7: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

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

# Main function that installs Homebrew packages and SWTOR for macOS's after Catalina
install_post_catalina() {

  echo -e "${PURPLE}\tStep 1: Create temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  create_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 2: Install Homebrew packages${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_package_wget_catalina
  install_package_winetricks_catalina
  install_package_cmake
  install_package_gcc
  install_package_bison
  install_package_xquartz
  install_package_flex
  install_package_mingw_w64
  install_package_pkg_config
  install_package_freetype

  echo -e "${PURPLE}\tStep 3: Download and compile patched Wine CrossOver 21${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  cd ~/swtor_tmp/ || exit
  download_crossover_21_patched
  unpack_crossover_21_tar
  compile_llvm
  compile_clang
  compile_wine

  echo -e "${PURPLE}\tStep 4: Create custom Wine prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  create_swtor_prefix

  echo -e "${PURPLE}\tStep 5: Install DLLs to prefix${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  install_dll_vcrun2008
  install_dll_crypt32
  install_dll_d3dx9_36

  echo -e "${PURPLE}\tStep 6: Change prefix settings${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ${NONE}"

  set_vram
  switch_windows_version
  switch_all_dlls_to_builtin

  echo -e "${PURPLE}\tStep 7: Download SWTOR executable${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  cd ~/swtor_tmp/ || exit
  download_swtor
  download_swtor_shortcut_zip
  cd ~/ || exit

  echo -e "${PURPLE}\tStep 8: Move executables and icon and move to prefix folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  move_swtor_setup
  move_swtor_shortcut_zip

  echo -e "${PURPLE}\tStep 9: Delete temporary downloads folder${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  delete_temporary_downloads_folder

  echo -e "${PURPLE}\tStep 10: Unzip SWTOR.zip and move application to Desktop${NONE}"
  echo -e "${PURPLE}\t‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾ ‾${NONE}"

  unzip_swtor_app
  move_swtor_app_to_desktop

  echo -e "${PURPLE}\tSWTOR On Mac Installation Finished Successfully!${NONE}"

  launch_swtor
}

check_if_not_high_sierra_or_earlier() {
    if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -lt $(echo "${EARLIEST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -lt $(echo "${EARLIEST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
      echo -e "${RED}\tERROR: SWTOR will only work on machines with macOS High Sierra (10.13) or later. The macOS of this machine is $CURRENT_VERSION. Exiting${NONE}"
      exit
    fi
}

echo -e "${PURPLE}\tAgentRG's SWTOR On Mac\n${NONE}"

check_if_not_high_sierra_or_earlier

# Check if Command Line Tools are installed followed by if Homebrew is installed
# If either isn't installed, the script will quit
if [ "$TOOLS_VERSION" = "$TOOLS_INSTALLED" ] || [ "$XCODE_CHECK" = "$XCODE_INSTALLED" ]; then
  if [[ $(command -v brew) == "" ]]; then
    echo -e "${RED}\tERROR: Homebrew not installed. Exiting.${NONE}"
  else
      if [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f1) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f1) ]] || [[ $(echo "${CURRENT_VERSION}" | cut -d"." -f2) -gt $(echo "${LAST_POSSIBLE_OS_TO_RUN_IN}" | cut -d"." -f2) ]]; then
        install_post_catalina
      else
        install_pre_catalina
      fi
  fi
else
  echo -e "${RED}\tERROR: Command Line Tools not installed. Exiting.${NONE}"
fi