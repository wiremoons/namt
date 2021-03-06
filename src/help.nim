##
## SOURCE FILE: help.nim
## 
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##


# import the required Nim standard library modules
import strformat, os

proc showHelp*() =
  ##
  ## PROCEDURE: showHelp
  ## Input: none required
  ## Returns: outputs help information to the display then quits the program
  ## Description: display command line help information requested by the user
  ##
  let appName = extractFilename(getAppFilename())
  echo fmt"""
Application to manage acronyms stored in a SQLite database.
Usage: {appName} [switches] [arguments]

[Switches]          [Arguments]      [Description] 
 -d, --delete         <rec_id>       delete an acronym record.  Argument is mandatory.
 -h, --help                          display help information.
 -n, --new                           add a new acronym record.
 -s, --search         <acronym>      find a acronym record.     Argument is mandatory.
 -u, --update         <rec_id>       update an existing record. Argument is mandatory.
 -v, --version                       show version information.

Arguments
<rec_id>  : unique number assigned to each acronym. Can be found with a '-s, --search'.
<acronym> : an acronym to be found in the database. Use quotes if contains spaces.
Use '%' for wildcard searches.
"""

# Allow module to be run standalone for tests
when isMainModule:
  showHelp()
