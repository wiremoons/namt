##
## SOURCE FILE: dbgUtils.nim
## 
## MIT License
## Copyright (c) 2021 Simon Rowe
## https://github.com/wiremoons/
##

template debug*(data: untyped) =
  ##
  ## PROCEDURE: debug
  ## Input: any debug message to be sent to stderr
  ## Returns: nothing
  ## Description: a Nim template used to output debug messages
  ## from a program. Is not used when a program is compiled
  ## as a 'release' version - allowing automatic disabling of
  ## debug output for final application builds. Output includes
  ## any message passed to the template, along with the source code
  ## file name, and line number the debug message originates from.
  ## To use, add this file 'dbgUtils.nim' to a project via an
  ## 'import' in the source code file it is needed for.
  when not defined(release):
    let pos = instantiationInfo()
    write(stderr, "DEBUG in " & pos.filename & ":" & $pos.line &
        " \"" & data & "\".\n")

# Allow this module to be run for standalone tests
when isMainModule:
  debug "This is a test debug message"
