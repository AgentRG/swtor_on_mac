# SWTOR On Mac [![Github All Releases](https://img.shields.io/github/downloads/agentrg/swtor_on_mac/total?color=%2376BA1B&style=for-the-badge)]()
Script written for macOS using Homebrew / Winetricks to install everything required for Star Wars: The Old Republic up to the point where the installer is launched.

![Untitled1](https://user-images.githubusercontent.com/23729455/142350151-69209849-bdc2-4ec8-a8d3-1e665cd49989.png)


### Install SWTOR On Mac
``` bash
curl -s https://raw.githubusercontent.com/AgentRG/swtor_on_mac/master/install.sh | bash
```

### Install SWTOR On Mac without Wine (assuming Wine/Wine32on64 is already installed):
```bash
curl -s https://raw.githubusercontent.com/AgentRG/swtor_on_mac/master/install_swtor.sh | bash
```

Prerequisite:
1. macOS High Sierra or later
2. Have both [Command Line Tools](https://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/ "How to Install Command Line Tools") and [Homebrew](https://github.com/Homebrew/install "Homebrew GitHub Page") installed.
3. At least 70GB of free storage space.

### Uninstall SWTOR On Mac
SWTOR On Mac can be uninstalled by simply moving the prefix folder to Trash.

To uninstall Wine:

macOS Mojave and earlier ( ≤ 10.14 )
* `brew uninstall agentrg-wine-stable`

macOS Catalina and after ( 10.15 ≤ )

Note: To uninstall Wine, you'll need to recompile LLVM/Clang/Wine from the sources folder to create Wine's Makefile since the script deletes the source folder once `make install-lib` ran successfully (otherwise ~20GB is wasted just to keep the sources folder)

* `cd to/sources/folder`
* `cd wine/`
* `sudo make uninstall`

If you also want to uninstall Homebrew and all the dependencies installed by it, run the following commands:
1. ```brew list | xargs brew uninstall --force```
2. ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"```
