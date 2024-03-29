##
## SOURCE FILE: namt.nim
##
## MIT License
## Copyright (c) 2021 Simon Rowe
##
## https://github.com/wiremoons/namt

# nim c -r .\namt.nim

# import the required Nim standard library modules
import os, strformat

# import our own local modules
import dbgUtils, dbManage, types, version, help


###############################################################################
# PROGRAM START (MAIN)
###############################################################################

debug "WARNING: running with a 'debug' build."
debug "Rebuild with: `nimble release` if required."

# structure to manage DB status for program as module 'types.nim'
var dbState = DBState()
debug "Initial DB status: " & repr(dbState)

initDbState(dbState)

# check for command line options use
let args = commandLineParams()
if paramCount() > 0:
  case args[0]
  of "-h", "--help", "-?", "?":
    echo ""
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
    debug fmt"Running search requested via '-s' or '--search'"
    if paramCount() != 2 or args[1].len == 0:
      writeLine(stderr,fmt"ERROR: for '-s' or '--search' option please provide an acronym to search for. Exit.")
      quit(QuitFailure);
    if not searchDb(dbState, args[1]): quit(QuitFailure) else: quit(QuitSuccess)
  of "-u", "--update":
    echo "TODO: implement update record"
  of "-c", "--create":
    createNewDb(dbState)
  else:
    debug fmt"Running default action to search for: '{args[0]}'"
    if args[0].len == 0 or not searchDb(dbState, args[0]):
      writeLine(stderr,fmt"ERROR: default search action for '{args[0]}' failed. Exit.")
      quit(QuitFailure);
else:
  debug "No command line options detected - displaying default output..."
  showVersion()
  showDbInfo(dbState)
  showHelp()
  writeLine(stderr,"ERROR: no command line option selected. Exit.")
  quit(QuitSuccess)

# ensure "exit procedures" are run if needed
quit(QuitSuccess)
