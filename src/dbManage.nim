##
## SOURCE FILE: dbManage.nim
## 
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##

# import the required Nim standard library modules
import strformat, os

# import our own modules from this apps source code repo
import dbgUtils, types, yesno

proc initDbState*(dbState:DBState) =
  # initialise the SQLite Database structure of status. Used
  # to track the database location, filename, records, etc

  # Check if DB file location is given via environment variable: 'ACRODB'
  dbState.dbFullPath = getEnv("ACRODB", "")
  debug fmt"Checking env 'ACRODB': '{dbState.dbFullPath}'" 
  if not fileExists(dbState.dbFullPath):
    if dbState.dbFullPath.len > 0:
      writeLine(stderr, fmt"ERROR: 'ACRODB' is set to: '{dbState.dbFullPath}' but does not exist.")
  else:
    dbState.dbFound = true
    dbState.dbFileName = extractFilename(dbState.dbFullPath)
    debug "Updated DB status: " & repr(dbState)
    return

  # Check if DB file location is in same location as program executable
  dbState.dbFileName = "acronyms.db"
  dbState.dbFullPath = joinPath(getAppDir(),dbState.dbFileName)
  debug fmt"Checking for local DB file: '{dbState.dbFullPath}'" 
  if fileExists(dbState.dbFullPath):
    dbState.dbFound = true
    dbState.dbFileName = extractFilename(dbState.dbFullPath)
    debug "Updated DB status: " & repr(dbState)
    return

  debug "Execution of proc 'initDbState' failed to find a database file."
  dbState.dbFound = false
  dbState.dbFileName = "UNKNOWN"
  dbState.dbFullPath = "UNKNOWN"
  debug "DB status after failure: " & repr(dbState)


proc showDbInfo*(dbState:DBState) =
  # display a cpy of the database state structure
  echo "Database status:"
  debug "Database structure: " & repr(dbState)
  echo fmt" - Database file name: '{dbState.dbFileName}'"
  echo fmt" - Database full path: '{dbState.dbFullPath}'"
  echo fmt" - Database file size: '{dbState.dbFileSize}' bytes"
  echo fmt" - Database modified:  '{dbState.dbFileModTime}'"
  echo ""
  echo fmt" - SQLite version: '{dbState.dbSqliteVersion}'"
  echo fmt" - Total acronyms: '{dbState.dbRecordCount}'"
  echo fmt" - Last acronym entered: '{dbState.dbLastRecordName}'"
  echo ""


proc createNewDb*(dbState:DBState) {.noreturn} =
    # Create a new acronyms database
    if not dbState.dbFound:
      # no database found - see if one should be created?
      if getYesNo("Would you like to create a new acronyms database?"):
        echo "TODO: create a new database for the user"
        quit()
    else:
      writeLine(stderr, "ERROR: Unable to create a new database file - existing file found.")
      writeLine(stderr, fmt" - remove the current database first: '{dbState.dbFullPath}'.")
      quit()

