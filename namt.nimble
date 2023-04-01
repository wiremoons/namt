# Package

version       = "0.4.2"
author        = "Simon Rowe [wiremoons]"
description   = "Nim Acronym Management Tool (NAMT) manages acronyms stored in a SQLite database."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["namt"]


# Dependencies

requires "nim >= 1.4.8"

# Tasks

task release, "Builds a release version":
  echo("\nRelease Build...\n")
  #exec("nimble build -d:release --gc:orc --passC:-march=native")
  exec("nimble build -d:release --gc:orc --app:console")

task debug, "  Builds a debug version":
  echo("\nDebug Build\n")
  exec("nimble build --gc:orc -d:debug --lineDir:on --debuginfo --debugger:native")

task windows, "Builds a release version for 64bit Windows":
  echo("\nWindows Release Build...\n")
  # Ubuntu: apt install mingw-w64
  # macOS: brew install mingw-w64
  exec("nimble build -d:release -d:mingw --gc:orc --app=console --cpu=amd64")

# pre runner for 'exec' to first carry out a 'debug' task build above
before exec:
  exec("nimble debug")

# runs the 'debug' version
task exec, "   Builds and then runs a debug version":
  echo("\nDebug Run\n")
  exec("./bin/namt")
