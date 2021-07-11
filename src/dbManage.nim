##
## SOURCE FILE: dbManage.nim
## 
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##

# import the required Nim standard library modules
import db_sqlite, strformat, strutils, times, os

# import our own local modules
import dbgUtils, types, yesno


proc getDbConnection(dbState:DBState): bool =
  ## dbManage.getDbConnection :  Obtain a connection to the SQLite database file
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
  ## dbManage.getSqliteVersion : obtain the version of SQLite being used
  ## Uses SQL: "SELECT sqlite_version()";
  dbState.dbSqliteVersion = dbState.db.getValue(sql"SELECT sqlite_version()")
  if dbState.dbSqliteVersion.len > 0: result = true else: result = false


proc getTotalRecords(dbState:DBState):bool =
  ## dbManage.getTotalRecords : obtain the total number of acronyms records in the SQLite database
  ## Uses SQL: "select printf('%,d', count(*)) from ACRONYMS";
  dbState.dbRecordCount = dbState.db.getValue(sql"select printf('%,d', count(*)) from ACRONYMS")
  if dbState.dbRecordCount.len > 0: result = true else: result = false


proc getLastAcronym(dbState:DBState):bool =
  ## dbManage.getLastAcronym : obtain the last acronym added to the SQLite database
  ## Uses SQL: "SELECT Acronym FROM acronyms Order by rowid DESC LIMIT 1";
  dbState.dbLastAcronym = dbState.db.getValue(sql"SELECT Acronym FROM acronyms Order by rowid DESC LIMIT 1")
  if dbState.dbLastAcronym.len > 0: result = true else: result = false


proc getDbFileSize(dbState:DBState):bool =
  ## dbManage.getDbFileSize : obtain the file size for the SQLite database
  try:
    dbState.dbFileSize = insertSep($getFileSize(dbState.dbFullPath),sep=',')
    return true
  except:
    stderr.writeLine(getCurrentExceptionMsg())
    return false

proc getDbModTime(dbState:DBState):bool =
  ## dbManage.getDbModTime : obtain the file modification time for the SQLite database
  try:
    let fileTime:Time = getLastModificationTime(dbState.dbFullPath)
    dbState.dbFileModTime = $fileTime.format("ddd dd MMM yyyy HH:mm:ss")
    return true
  except:
    stderr.writeLine(getCurrentExceptionMsg())
    return false

proc initDbState*(dbState:DBState) =
  ## dbManage.initDbState : locate the SQLite database file and initialise the applications state structure.

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

  # Check if DB file location is in same location as program executable
  if not dbState.dbFound:
    dbState.dbFileName = "acronyms.db"
    dbState.dbFullPath = joinPath(getAppDir(),dbState.dbFileName)
    debug fmt"Checking for local DB file: '{dbState.dbFullPath}'" 
    if fileExists(dbState.dbFullPath):
      dbState.dbFound = true
      dbState.dbFileName = extractFilename(dbState.dbFullPath)
      debug "Updated DB status: " & repr(dbState)

  # If a SQLite database was found - populate the application state structure
  if dbState.dbFound:
    if getDbConnection(dbState):
      debug "Database connection OK"
      if not getSqliteVersion(dbState): writeLine(stderr, "ERROR: unable to get SQLite version")
      if not getTotalRecords(dbState): writeLine(stderr, "ERROR: unable to get total record count")
      if not getLastAcronym(dbState): writeLine(stderr, "ERROR: unable to get last acronym")
      if not getDbFileSize(dbState): writeLine(stderr, "ERROR: unable to SQLite database file size")
      if not getDbModTime(dbState): writeLine(stderr, "ERROR: unable to get SQLite database last modification time")
      debug "Updated DB status: " & repr(dbState)
  else: # no database file found
    debug "Execution of proc 'initDbState' failed to find a database file."
    dbState.dbFileName = "UNKNOWN"
    dbState.dbFullPath = "UNKNOWN"
    debug "DB status after failure: " & repr(dbState)


proc showDbInfo*(dbState:DBState) =
  ## dbManage.showDbInfo : display a copy of the applications state structure for the SQLite database
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
    ## dbManage.createNewDb : create a new acronyms database
    if not dbState.dbFound:
      # no database found - see if one should be created?
      if getYesNo("Would you like to create a new acronyms database?"):
        echo "TODO: create a new database for the user"
        quit()
    else:
      writeLine(stderr, "ERROR: Unable to create a new database file - existing file found.")
      writeLine(stderr, fmt" - remove the current database first: '{dbState.dbFullPath}'.")
      quit()
