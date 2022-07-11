#!/usr/bin/env arch -x86_64 bash

set -e

NONE='\033[00m'
PURPLE='\033[01;35m'


echo -e "${PURPLE}\tAgentRG's SWTOR On Mac\n${NONE}"
echo -e "${PURPLE}\tDeleting all files related to Wine listed in: wine-cx21.2.0_removal_list.txt\n${NONE}"

cd /
sudo curl -s https://raw.githubusercontent.com/AgentRG/swtor_on_mac/AgentRG-patch-32/uninstall/wine-cx21.2.0_removal_list.txt | bash
cd ~