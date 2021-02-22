==========================================================================
td.sh – super simple todo script
==========================================================================

1. COMMANDS:
------------
td "[:YY/mm/dd:] task [:@tag:]"		Add basic task to list
  –> td ":20/01/15: Buy milk :@Shopping:"
  –> td "Make 'it' work"

td [int] "task [:@tag:]"		Add date X days forward from today
  –> td 3 "Return homework"

tn "task [:@tag:]"			Add task scheduled for next day
  –> tdn "Call Mom :@Family:"

tw "task [:@tag:]"			Add task scheduled for next sunday
  –> tds "Pay rent"

tl					List all tasks

tt					List all tags and their frequency 

tld					List tasks scheduled for today

tlw					List tasks scheduled for this week

tf int [int] ... [int]			Mark tasks done with line numbers
  –> tdr 1 3 5

tft :@tag:				Mark all tasks done
  –> tg :@Home:
  - Case insensitive. Partial tags usable, e.g. 'work' matches :@Homework:

tfl					List all task that are marked done

tx					Delete log file

tdh					Print quickhelp list of commands

***** see below for setting aliases to these commands ******

2. SETTING SCRIPTS AND COMMANDS
-------------------------------

***** IMPORTANT *****
The scripts use basic command line utilities like sed, grep, cat, and awk.
The version of awk used  is  named 'mawk'. Install it,  or add an alias so
that the command 'mawk' uses some other version of awk.
*********************

It is recommended to place the folder in the system PATH.  This allows the
user to use the scripts  like commands, such as 'td' instead of './td.sh'.
Alternatively, if the system PATH cannot be used, the user may add aliases
to the scripts.

To use the commands listed above, the  following  aliases must be added to
the system. Optionally the user may create entirely different commands.

All the todo tasks are listed  in the .todo file in the same folder as the
scripts. The entries are separated by a newline.  Tasks can also  be added
by hand to this file, as long as they follow the correct syntax.

alias tn="td -n"
alias tw="td -w"
alias tu="td -u"
alias tt="tl -t"
alias tlu="tl -u"
alias tld="tl -d"
alias tlw="tl -w"
alias tft="tf -t"
alias tx="tf -log"
alias tfl="tf -list"
alias tdh="tl -h"

3. HOW IT WORKS
---------------
All the todo tasks are listed  in the .todo file in the same folder as the
scripts. The entries are separated by a newline.  Tasks can also  be added
by hand to this file, as long as they follow the correct syntax.

3.1 SYNTAX
----------
In the most basic form, a task is just a string of text. In addition, some 
optional labels may be added to the task.  There are three labels:  a DATE 
the task is scheduled for,  an "URGENT" label, or a TAG to the entry. Date
and the urgent label are mutually exclusive.

All these optional labels are marked with surrounding colons. In addition,
the tag must be preceded by the at sign '@'. For example:

– Date –> :20/01/15: means the 15th of January 2020. (Format is YY/mm/dd)

– Urgent –> :!!:

– Tag –> :@Work: or :@work: etc. Any string can be used.

3.2 CREATING TASKS
------------------
Tasks can be created by writing the task and  all optional labels manually 
when using the 'td' command,  or by using the shortcuts described above in 
the COMMANDS section.

Tasks are  sorted immediately after a task has been created.  If a task is
added by hand to the .todo file, they are not sorted until the next time a
command is used to create a task. The urgents tasks are listed first, then
those with a date, and lastly all other tasks.

3.3 LISTING TASKS
-----------------
The predefined commads are used to list all recorded tasks, or only urgent
tasks, or tasks scheduled for today or this week.  When listing all tasks,
they are printed with line numbers. These line numbers can be used to mark
tasks done.

3.4 MARKING TASKS DONE
----------------------
When using the 'tf' command to mark tasks done,  they are removed from the
.todo file and added to the .tdlog file.  The date is also recorded to the
log, so it is possible to see when certain tasks were finished.

The default maximum amount of logged tasks is 80. When more are added, old
logged tasks are deleted.  The maximum amount is controlled by the LOG_MAX
global variable in the tf.sh script.  The log can also be cleared with the 
'tx' command.

When marking tasks done with line numbers, only entries that are valid
line numbers are processed. 

==========================================================================
Copyright (c) 2021 Matias Ikkala

This file is part of td.sh.

Td.sh is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Td.sh is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with td.sh.  If not, see <https://www.gnu.org/licenses/>.

