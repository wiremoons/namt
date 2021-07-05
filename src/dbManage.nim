##
## SOURCE FILE: dbManage.nim
## 
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##

# import the required Nim standard library modules
import strformat, os, db_sqlite

# import our own modules from this apps source code repo
import dbgUtils, types, yesno


proc getDbConnection(dbState:DBState): bool =
  # Attempt to connect to the SQLite database file
  debug fmt"Attempting to open database connection to: '{dbState.dbFullPath}'"
  try:
    dbState.db = open(dbState.dbFullPath, "", "", "")
    return true
  except:
    stderr.writeLine(getCurrentExceptionMsg())
    return false


#proc searchDb*()=
  #"Select rowid, ifnull(Acronym,''), ifnull(Definition,''), ifnull(Description,''), ifnull(Source,'') from Acronyms where Acronym like ?1 COLLATE NOCASE ORDER BY Source";


proc getSqliteVersion(dbState:DBState):bool =
  # "SELECT sqlite_version()";
  dbState.dbSqliteVersion = dbState.db.getValue(sql"SELECT sqlite_version()")
  if dbState.dbSqliteVersion.len > 0: result = true else: result = false


proc getTotalRecords(dbState:DBState):bool =
  # "select printf('%,d', count(*)) from ACRONYMS";
  dbState.dbRecordCount = dbState.db.getValue(sql"select printf('%,d', count(*)) from ACRONYMS")
  if dbState.dbRecordCount.len > 0: result = true else: result = false


proc getLastAcronym(dbState:DBState):bool =
  # "SELECT Acronym FROM acronyms Order by rowid DESC LIMIT 1";
  dbState.dbLastAcronym = dbState.db.getValue(sql"SELECT Acronym FROM acronyms Order by rowid DESC LIMIT 1")
  if dbState.dbLastAcronym.len > 0: result = true else: result = false


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

  if not dbState.dbFound:
    # Check if DB file location is in same location as program executable
    dbState.dbFileName = "acronyms.db"
    dbState.dbFullPath = joinPath(getAppDir(),dbState.dbFileName)
    debug fmt"Checking for local DB file: '{dbState.dbFullPath}'" 
    if fileExists(dbState.dbFullPath):
      dbState.dbFound = true
      dbState.dbFileName = extractFilename(dbState.dbFullPath)
      debug "Updated DB status: " & repr(dbState)

  if dbState.dbFound:
    if getDbConnection(dbState):
      debug "Database connection OK"
      if not getSqliteVersion(dbState): writeLine(stderr, "ERROR: unable to get SQLite version")
      if not getTotalRecords(dbState): writeLine(stderr, "ERROR: unable to get total record count")
      if not getLastAcronym(dbState): writeLine(stderr, "ERROR: unable to get last acronym")
      debug "Updated DB status: " & repr(dbState)
  else:
    debug "Execution of proc 'initDbState' failed to find a database file."
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
  echo fmt" - Last acronym entered: '{dbState.dbLastAcronym}'"
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
