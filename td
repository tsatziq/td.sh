#!/bin/bash

############################################################
# Project: td.sh – super simple todo script
# Part: 2/3
# Description: Scripts to save and sort tasks
# Author: Matias Ikkala
# Email: matias.ikkala@gmail.com
############################################################

# Default todo file
readonly SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
readonly FILE_PATH=$SCRIPT_PATH/.todo

write_entry() {
  # Append to .todo, and sort right after.
  echo $1 >> $FILE_PATH

  # First overwrite tmp with urgent lines
  mawk '$1 ~ /^:!!:$/ {print}' $FILE_PATH > $SCRIPT_PATH/.tdtmp

  # Append lines with deadlines
  mawk '$1 ~ /^:[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]:$/ {dates[NR]=$0} \
  END { \
    for (date in dates){ \
      print dates[date] \
    } \
  }' $FILE_PATH | sort >> $SCRIPT_PATH/.tdtmp

  # Lastly append all else
  mawk '($1 !~ /^:!!:$/ && $1 !~ /^:[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]:$/) \
  {print}' $FILE_PATH >> $SCRIPT_PATH/.tdtmp

  # Overwrite to todo and remove
  cat $SCRIPT_PATH/.tdtmp > $FILE_PATH
  rm $SCRIPT_PATH/.tdtmp
}

# Check number of arguments and proceed accordingly

# Schedule X days forward easily with number
if [[ $# == 2 && $1 =~ ^[0-9]+$ ]]; then
  input_date=`date -d "+$1 days" +":%g/%m/%d:"`
  write_entry "$input_date $2"

# AUtomatical urgent task
elif [[ $# == 2 && $1 = "-u" ]]; then
  write_entry ":!!: $2"

# Write date yourself in the correct format
elif [[ $# == 1 ]]; then
  # Do not proceed if command was typed without entry
  if [[ $1 != "-u" && $1 != "-n" && $1 != "-w" ]]; then
  write_entry "$1"
  fi

# Automatical task scheduled for tomorrow
elif [[ $# == 2 && $2 == "-n" ]]; then
  next_day=`date -dtomorrow +":%g/%m/%d:"`
  write_entry "$next_day $1"

# Automatical task scheduled for end of this week
elif [[ $# == 2 && $2 == "-w" ]]; then
  next_sunday=`date -dsunday +":%g/%m/%d:"`
  write_entry "$next_sunday $1"

else
#Print error message
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

