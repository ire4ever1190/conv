import std/strutils
import std/parseutils
import common
import std/os
import std/options
import constants

when isMainModule:
  var
    conf: CmdConf
    hasInFormat = false
    hasOutFormat = false
  for param in commandLineParams():
    # Handle flags
    if param.startsWith("-") or param.startsWith("--"):
      var 
        i = 0
        key, value: string
      i += param.skipWhile({'-'})
      i += param.parseUntil(key, '=', start=i)
      if i < param.len and param[i] == '=': # There is a value portion
        value = param[i + 1 .. param.len - 1]
      case key
      of "v", "version":
        quit(version, 0)
      of "h", "help":
        quit(helpMsg, 0)
      of "length":
        try:
          conf.outLength = some value.parseInt()
        except ValueError:
          quit("Length (" & value & ") is not a number")
      else:
        quit("Invalid argument: " & param, 1)
    # Handle formats
    else:
      let format = cast[NumberFormat](param[0])
      # TODO: Make macro or something so we don't need to manually add enums
      if format in supportedFormats:
        if not hasInFormat:
          conf.inFormat = format
          if param.len == 1:
            quit("Input value is not provided", 1)
          conf.input = param[1..^1]
          hasInFormat = true
            
        elif not hasOutFormat:
          conf.outFormat = format
          hasOutFormat = true
        else:
          # Maybe allow user to convert multiple at once?
          quit("Only two formats can be specified", 1) 

  # Check user has specified both in and out formats
  if not hasInFormat:
    quit("Input format not specified", 1)
  elif not hasOutFormat:
    quit("Output format not specified", 1)
  try:
    quit(conf.fromIn().toOut(conf), 0)
  except InvalidFormatError:
    quit(getCurrentExceptionMsg(), 1)
      
      
