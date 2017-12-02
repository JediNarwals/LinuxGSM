#!/bin/bash
# LinuxGSM command_update_linuxgsm.sh function
# Author: JediNarwals [TG]
# Description: Deletes the Mission dir to allow re-downloading of functions from GitHub.

local commandname="UPDATE"
local commandaction="Update"
local function_selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

fn_print_dots "Updating Missions"
#sleep 1
echo -ne "\n"
cd ${serverfiles}
svn checkout https://github.com/${githubmissionusr}/${githubmissionsrepo}/${githubmissionsbranch}/${githubmissionsfiles}

echo -ne "\n"
core_exit.sh
