# SWTOR On Mac [![Github All Releases](https://img.shields.io/github/downloads/agentrg/swtor_on_mac/total?color=%2376BA1B&style=for-the-badge)]()
Script written for macOS using Homebrew / Winetricks to install everything required for Star Wars: The Old Republic up to the point where the installer is launched.

### Install SWTOR On Mac
``` bash
curl -s https://raw.githubusercontent.com/AgentRG/swtor_on_mac/master/install.sh | bash
```
Prerequisite:
1. macOS High Sierra or later
2. Have both [Command Line Tools](https://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/ "How to Install Command Line Tools") and [Homebrew](https://github.com/Homebrew/install "Homebrew GitHub Page") installed.

### Uninstall SWTOR On Mac
SWTOR On Mac can be uninstalled by simply moving the prefix folder to Trash.

If you also want to uninstall Homebrew and all the dependencies installed by it, run the following commands:
1. ```brew list | xargs brew uninstall --force```
2. ```ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"```
