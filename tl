#!/bin/bash

############################################################
# Project: td.sh – super simple todo script
# Part: 1/3
# Description: Scripts that list current todo tasks
# Author: Matias Ikkala
# Email: matias.ikkala@gmail.com
############################################################

# Default todo file and date
readonly SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
readonly FILE_PATH=$SCRIPT_PATH/.todo

# First check arguments and proceed accordingly

# List found tags
if [[ $# == 1 && $1 == "-t" ]]; then
  mawk '/:@.+:$/ {tags[$NF]++} \
  END{ if (length(tags) > 0){ \
      print("List of tags found:")
      for (tag in tags){ \
        printf "\033[36m%-15s\033[0m \t\033[1m\033[35m%2s\033[0m\n",
        tag,tags[tag]
      }} else { \
        print("No tags found")
      } \
  }' $FILE_PATH

# List tasks scheduled for today 
elif [[ $# == 1 && $1 == "-d" ]]; then
  mawk -vdate=`date +":%g/%m/%d:"` '$1 == date { \
    todo[NR]=(substr($0,index($0,$2)))}
  END{ if (length(todo) > 0){ \
    print("\033[1m\033[32mTODO TODAY:\033[0m")
    for (var in todo){ \
      print("–", todo[var]) \
    }} else{ \
      print("Nothing scheduled for today") \
    } \
  } \
  ' $FILE_PATH

# List all urgent tasks
elif [[ $# == 1 && $1 == "-u" ]]; then
  mawk '$1 == ":!!:" {tasks[NR]=substr($0,index($0,$2))} \
  END{ if (length(tasks) > 0){ \
    print("\033[1m\033[38;5;203m!!! :URGENT: !!!\033[0m")
    for (task in tasks){ \
      print("–", tasks[task]) \
    }} else{ \
      print("No urgent tasks") \
    } \
  } \
  ' $FILE_PATH

# List tasks scheduled for this week
elif [[ $# == 1 && $1 == "-w" ]]; then
  mawk -vweekdl=`date -dsunday +:%g/%m/%d:` -vdate=`date +:%g/%m/%d:` ' \
  $1 ~ /^:[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]:$/ { \
    if ($1 >= date && $1 < weekdl){ \
      todo[NR]=$0 \
    } \
  } \
  END{ if (length(todo) > 0){ \
    print("\033[1m\033[32mTODO THIS WEEK:\033[0m")
    for (var in todo){ \
      printf "\033[1m\033[34m%-10s\033[0m \t%-s\n", substr(todo[var],0,11),
        substr(todo[var],12) \
      } \
    } else{ \
      print("Nothing scheduled for this week") \
    } \
  } \
  ' $FILE_PATH

# List all tasks when no arguments are passed
elif [[ $# == 0 ]]; then
  # Formatted print as one long command
  mawk '$1 ~ /^:!!:$/ { \
    printf "\033[32m(%s)\033[0m \033[1m\033[35m%-3s%-s%-3s\033[0m\
 \t\033[1m\033[31m%-s\033[0m\n", NR,"",$1,"",substr($0,index($0,$2))} \
  $1 ~ /^:[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]:$/ { \
    printf "\033[32m(%s)\033[0m \033[38;5;214m%-10s\033[0m\
 \t\033[38;5;120m%-s\033[0m\n", NR,$1,substr($0,12)} \
  ($1 !~ /^:!!:$/ && $1 !~ /^:[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9]:$/) \
  {printf "\033[32m(%s)\033[0m %-9s \t%-s\n", NR,"",$0} \
  ' $FILE_PATH


# Print quickhelp list of commands
elif [[ $# == 1 && $1 == "-h" ]]; then
  mawk 'BEGIN{FS=";"} { \
    printf "\033[1m\033[32m%-31s\033[0m \t%-s\n", $1,$2}' \
    $SCRIPT_PATH/shorthelp.txt

# Print error message
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

