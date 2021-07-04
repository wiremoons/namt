##
## SOURCE FILE: namt.nim
##
## MIT License
## Copyright (c) 2021 Simon Rowe
##
## https://github.com/wiremoons/namt

# nim c -r .\namt.nim

# import the required Nim standard library modules
import os

# import our own modules from this apps source code repo
import dbgUtils, dbManage, types, version, help


###############################################################################
# PROGRAM START (MAIN)
###############################################################################

debug "WARNING: running with a 'debug' build."

# structure to manage DB status for program
var dbState = DBState()
debug "Initial DB status: " & repr(dbState)

initDbState(dbState)

# check for command line options use
let args = commandLineParams()
if paramCount() > 0:
  case args[0]
  of "-h", "--help", "-?", "?":
    showHelp()
    quit 0
  of "-v", "--version":
    showVersion()
    quit 0
  of "-d", "--delete":
    echo "TODO: implement delete records"
  of "-n", "--new":
    echo "TODO: implement new records"
  of "-s", "--search":
    echo "TODO: implement search records"
  of "-u", "--update":
    echo "TODO: implement update record"
  of "-c", "--create":
    createNewDb(dbState)
  else:
    echo "TODO: implement search records for default action with unknown cli param"
else:
  debug "no command line options given"
  showVersion()
  showDbInfo(dbState)
  showHelp()
  writeLine(stderr,"ERROR: no command line option selected. Exit.")
  quit(QuitSuccess)

# ensure "exit procedures" are run if needed
quit(QuitSuccess)
