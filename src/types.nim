import db_sqlite

type
  DBState* = ref object
    dbFound*: bool
    dbFullPath*: string
    dbFileName*: string
    dbFileSize*: string
    dbRecordCount*: string
    dbLastAcronym*: string
    dbFileModTime*: string
    dbSqliteVersion*:string
    db*: DbConn
