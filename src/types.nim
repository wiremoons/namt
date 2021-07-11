##
## SOURCE FILE: types.nim
##
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##

# import the required Nim standard library modules
import db_sqlite

# types.DBState : applications state structure object
type
  DBState* = ref object
    dbFound*: bool              # loctaed a SQLite database file path
    dbFullPath*: string         # full path and filename for the SQLite database file
    dbFileName*: string         # filename only for SQLite database file (ie no path)
    dbFileSize*: string         # size in bytes as a string for the SQlite database file
    dbFileModTime*: string      # last file modification timestamp for the SQLite database file
    dbRecordCount*: string      # number of acronym records in the SQLite database
    dbLastAcronym*: string      # last acronym entered into the SQLite database
    dbSqliteVersion*:string     # The version of the SQLite being used by this application
    db*: DbConn                 # SQLite database connection handle
