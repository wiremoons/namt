type
  DBState* = ref object
    dbFound*: bool
    dbFullPath*: string
    dbFileName*: string
    dbFileSize*: string
    dbRecordCount*: int
    dbLastRecordName*: string
    dbFileModTime*: string
    dbSqliteVersion*:string
