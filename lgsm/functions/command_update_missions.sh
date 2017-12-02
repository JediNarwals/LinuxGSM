#!/bin/bash
# LinuxGSM command_update_linuxgsm.sh function
# Author: Daniel Gibbs
# Website: https://gameservermanagers.com
# Description: Deletes the functions dir to allow re-downloading of functions from GitHub.

local commandname="UPDATE Missions"
local commandaction="Update Missions"
local function_selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

fn_print_dots "Updating Missions"
sleep 1
check.sh
fn_script_log_info "Updating Missions"
echo -ne "\n"

# Check and update functions
if [ -n "${missionsfile}" ]; then
	if [ -d "${missionsfile}" ]; then
		cd "${missionsfile}"
		for $i in *
		do
			echo -ne "    checking function ${$i}...\c"
			github_missions_file_url_dir="serverfiles/mpmissions"
			get_function_file=$(${curlpath} --fail -s "https://raw.githubusercontent.com/${githubmissionsusr}/${githubmissionsrepo}/${githubmissionsbranch}/${githubmissionsfiles}/${$i}")
			exitcode=$?
			mission_file_diff=$(diff "${missionsfile}/${functionfile}" <(${curlpath} --fail -s "https://raw.githubusercontent.com/${githubmissionsusr}/${githubmissionsrepo}/${githubmissionsbranch}/${githubmissionsfiles}/${$}"))
			if [ ${exitcode} -ne 0 ]; then
				fn_print_fail_eol_nl
				echo -ne "    removing unknown mission ${$i}...\c"
				fn_script_log_fatal "removing unknown mission ${$i}"
				rm -f "${$i}"
				if [ $? -ne 0 ]; then
					fn_print_fail_eol_nl
					core_exit.sh
				else
					fn_print_ok_eol_nl
				fi
			elif [ "${mission_file_diff}" != "" ]; then
				fn_print_update_eol_nl
				fn_script_log_info "checking mission ${$i}: UPDATE"
				rm -rf "${missionsfile}/${$i}"
				fn_update_function
			else
				fn_print_ok_eol_nl
			fi
		done
	fi
fi

if [ "${exitcode}" != "0" ]&&[ -n "${exitcode}" ]; then
	fn_print_fail "Updating missions"
	fn_script_log_fatal "Updating missions"
else
	fn_print_ok "Updating missions"
	fn_script_log_pass "Updating missions"
fi
echo -ne "\n"
core_exit.sh
