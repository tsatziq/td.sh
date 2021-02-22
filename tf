#!/bin/bash

############################################################
# Project: td.sh – super simple todo script
# Part: 3/3
# Description: Scripts to mark tasks done and delete them
# Author: Matias Ikkala
# Email: matias.ikkala@gmail.com
############################################################

# Default todo file and max line amount of log
readonly SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
readonly FILE_PATH=$SCRIPT_PATH/.todo
readonly LOG_PATH=$SCRIPT_PATH/.tdlog
readonly LOG_MAX=80

# Check if log is at max length and clear
trunc_log() {
  local lines_now=$((`wc -l< $LOG_PATH`))
  local lines_after=$((`wc -l< $LOG_PATH`+$1))

  # Check if file needs truncating and calculate how much
  if [[ $lines_after > $LOG_MAX ]]; then
    local remove_lines=$(($lines_after-$LOG_MAX))
   
    if [[ $remove_lines < $lines_now ]]; then
      local remove_from=$(($lines_now-$remove_lines))
      sed -i "$remove_from,$ d" $LOG_PATH
    else
      truncate -s 0 $LOG_PATH
    fi
  fi
}

# Function to mark entries to log with timestamps and filter the list
filter_list() {
  # Have to use intermediary files to do this
  grep -v -x -F -f $SCRIPT_PATH/.dtmp $FILE_PATH > $SCRIPT_PATH/.ftmp
  sed -i -e "s/^/[DONE: $(date '+%g\/%m\/%d')] /" $SCRIPT_PATH/.dtmp
  cat $SCRIPT_PATH/.dtmp | cat - $LOG_PATH > /tmp/out && mv -f /tmp/out $LOG_PATH
  mv -f $SCRIPT_PATH/.ftmp $FILE_PATH; rm $SCRIPT_PATH/.dtmp
}

# First check arguments and proceed accordingly

# Mark entries as done by a tag
if [[ $# == 2 && $1 == "-t" ]]; then
  mawk -vtag=$2 -voutfile="$SCRIPT_PATH/.dtmp" ' \
    tolower($NF) ~ tolower(tag) {print $0 >> outfile}' $FILE_PATH
  
  if [[ -f "$SCRIPT_PATH/.dtmp" ]]; then
    to_add=`wc -l < $SCRIPT_PATH/.dtmp`
    trunc_log $to_add
    filter_list
  else
    echo "No entries found with the provided tag"
  fi

# Clear log file
elif [[ $# == 1 && $1 == "-log" ]]; then
  read -p "Clear .tdlog? (y/n): " answer
  if [[ $answer == "y" ]]; then
    truncate -s 0 $LOG_PATH
  fi

# Print the log file
elif [[ $# == 1 && $1 == "-list" ]]; then
  mawk '$0 ~ /^\[DONE: [0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]]/ { \
    printf "\033[92m%-s\033[0m %-s\n", substr($0,0,16),substr($0,17)} \
  $0 !~  /^\[DONE: [0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]]/ { \
    print}' $LOG_PATH

# Give numbers to mark those lines done
elif [[ $# != 0 ]]; then
  line_no=`wc -l < $FILE_PATH`

  # Check that arguments are numbers and valid line numbers
  for i in $@; do  
    if [[ $i =~ ^[0-9]+$ && ($i -le $line_no) ]]; then
      mawk -vline=$i -voutfile="$SCRIPT_PATH/.dtmp" ' \
        NR==line {print $0 >> outfile}' $FILE_PATH
    fi
  done

  # If tasks were found, filter list, or print error message
  if [[ -f "$SCRIPT_PATH/.dtmp" ]]; then
    added_lines=`wc -l < $SCRIPT_PATH/.dtmp`
    trunc_log $added_lines
    filter_list
  else
    echo "No tasks found with given line numbers"
  fi
  
else
  echo "Command not known, type 'tdh' for help"
fi

########################## LICENSE ###########################
# Copyright (c) 2021 Matias Ikkala
#
# This file is part of td.sh.
#
# Td.sh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Td.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with td.sh.  If not, see <https://www.gnu.org/licenses/>.

