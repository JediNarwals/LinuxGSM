#!/bin/bash
#This is a test file to figure out how to write to a file in Linux
file_name="modslist"
function mod_questions() {
  if [ ! -f "${file_name}" ]; then
    touch ${file_name}
  fi
  echo "What is the name of the mod you would like to add to this file? "
  read modname
  echo "What is the appid from the steam workshop? "
  read appid
  i=0
  while read -r LINE; do (( i++ )); done < ${file_name}
  DL_NM="DL_NM${i}=@${modname}"
  DL_MD="DL_MD${i}=${appid}"
  output="${DL_NM} ${DL_MD}"
  echo "${output}" >> ${file_name}
  echo "Your imput has been put into the modslist. Thank you!"
  echo "Would you like to add another mod? Y or N"
  read choice
  case "$choice" in
    y|Y|yes|Yes ) mod_questions; break;;
    n|N|no|No ) exit 0;;
  esac
}
clear
echo "This is a test script for writing to a file"
echo ""

mod_questions
