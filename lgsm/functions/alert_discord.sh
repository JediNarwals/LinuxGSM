#!/bin/bash
# LinuxGSM alert_discord.sh function
# Author: Daniel Gibbs
# Contributor: faflfama
# Website: https://gameservermanagers.com
# Description: Sends Discord alert.

json=$(cat <<EOF
{
"username":"Arma Server",
"avatar_url":"https://i.imgur.com/8rrLdon.png",
"file":"content",

"embeds": [{
	"color": "2067276",
	"author": {"name": "${alertemoji} ${alertsubject} ${alertemoji}"},
	"title": "",
	"description": "",
	"url": "",
	"type": "content",
	"thumbnail": {"url": "https://i.imgur.com/8rrLdon.png"},
	"footer": {"text": "LinuxGSM", "icon_url": "https://i.imgur.com/8rrLdon.png"},
	"fields": [
			{
				"name": "Alert Message",
				"value": "${alertbody}"
			},
			{
				"name": "Game",
				"value": "${gamename}"
			},
			{
				"name": "Server name",
				"value": "${servername}"
			},
			{
				"name": "Server IP",
				"value": "[${ip}:${port}](https://www.gametracker.com/server_info/${ip}:${port})"
			}
		]
	}]
}
EOF
)

fn_print_dots "Sending Discord alert"
sleep 0.5
discordsend=$(${curlpath} -sSL -H "Content-Type: application/json" -X POST -d """${json}""" ${discordwebhook})

if [ -n "${discordsend}" ]; then
	fn_print_fail_nl "Sending Discord alert: ${discordsend}"
	fn_script_log_fatal "Sending Discord alert: ${discordsend}"
else
	fn_print_ok_nl "Sending Discord alert"
	fn_script_log_pass "Sending Discord alert"
fi
