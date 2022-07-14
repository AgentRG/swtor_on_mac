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
1. macOS High Sierra or later.
2. Have installed [Command Line Tools](https://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/ "How to Install Command Line Tools"), [Homebrew](https://github.com/Homebrew/install "Homebrew GitHub Page") and [Rosetta 2](https://osxdaily.com/2020/12/04/how-install-rosetta-2-apple-silicon-mac/).
3. At least 70GB of free storage space.

### Uninstall SWTOR On Mac
SWTOR On Mac can be uninstalled by simply moving the prefix folder to Trash.

To uninstall Wine:

macOS Mojave and earlier ( ≤ 10.14 )
* `brew uninstall agentrg-wine-stable`

macOS Catalina and after ( 10.15 ≤ )

* `curl -s https://raw.githubusercontent.com/AgentRG/swtor_on_mac/master/uninstall/uninstall.sh | bash`


If you also want to uninstall Homebrew and all the dependencies installed by it, run the following commands:
1. ```brew list | xargs brew uninstall --force```
2. ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"```
