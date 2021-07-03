##
## SOURCE FILE: namt.nim
##
## MIT License
## Copyright (c) 2021 Simon Rowe
##
## https://github.com/wiremoons/namt

# nim c -r .\namt.nim

# import the required Nim standard library modules
import strformat, strutils, options, times, os, terminal

# import our own modules from this apps source code repo
import dbgUtils, version, help


###############################################################################
# MAIN HERE
###############################################################################

debug "WARNING: running with a 'debug' build."

# check for command line options use
let args = commandLineParams()
if paramCount() > 0:
  case args[0]
  of "-h", "--help":
    showHelp()
  of "-v", "--version":
    showVersion()
  of "-d", "--delete":
    echo "TODO: implement delete records"
  of "-n", "--new":
    echo "TODO: implement new records"
  of "-s", "--search":
    echo "TODO: implement search records"
  of "-u", "--update":
    echo "TODO: implement update record"
  else:
    echo "TODO: implement search records for default action with unknown cli param"
else:
  debug "no command line options given"
  showHelp()
