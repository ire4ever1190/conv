import std/strutils except parseInt
import std/parseutils
import std/options
import std/setutils

const intBits = sizeof(int) * 8


type
  NumberFormat* = enum
    Binary = 'b'
    Integer = 'i'
    Hex = 'x'


  CmdConf* = object
    outLength*: Option[int] ## Length for output number
    inFormat*, outFormat*: NumberFormat
    input*: string
    
  InvalidFormatError* = object of CatchableError


const supportedFormats* = fullSet(NumberFormat)

template raiseFormatError(message: string) =
  raise (ref InvalidFormatError)(msg: message)

proc highlightPart(str: string, section: HSlice[int, int]): string {.raises: [].} =
  ## Highlights a section of text by pointing arrows to it
  ## Assumes that str is a single line (Will cause issues if it isn't)
  ##
  ## e.g. I want someone to see this part
  ##                            ^^^^^^^^^
  result = str
  result &= '\n'
  result &= ' '.repeat(str.len) 
  for i in section:
    result[str.len + 1 + i] = '^'
  
  
proc toOut*(num: int, conf: CmdConf): string {.raises: [].}=
  ## Convert the number to output format
  # TODO: Optimise this to reduce needed string functions
  case conf.outFormat:
  of Binary:
    result = num.toBin(conf.outLength.get(intBits))
  of Integer:
    result = $num
  of Hex:
    result = num.toHex(conf.outLength.get(intBits))

  if conf.outLength.isNone:
    result = result.strip(chars = {'0'}, trailing=false)

proc fromIn*(conf: CmdConf): int {.raises: [InvalidFormatError].}=
  ## Convert the string containing the number to an in
  var parsedLength: int
  case conf.inFormat:
  of Binary:
    parsedLength = conf.input.parseBin(result)
  of Integer:
    parsedLength = conf.input.parseSaturatedNatural(result)
  of Hex:
    parsedLength = conf.input.parseHex(result)


  if parsedLength == 0:
    raiseFormatError("Input is not in " & toLowerAscii($conf.inFormat) & " format")
  elif parsedLength != conf.input.len:
    # Underline the part of the input that is incorrect and present to user
    var msg = "Input is not fully in " & toLowerAscii($conf.inFormat) & " format: "
    let startLength = msg.len + parsedLength
    msg &= conf.input
    msg = msg.highlightPart(startLength .. startLength + (conf.input.len - parsedLength - 1))
    raiseFormatError(msg)

when isMainModule:
  echo highlightPart("This part is done", 5..8)
  assert highlightPart("This part is done", 5..8).strip() == """
This part is done
     ^^^^
""".strip()
