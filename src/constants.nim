import os
import std/strutils
const version* = readFile(currentSourcePath().parentDir.parentDir / "version").strip()

const helpMsg* = """
Basic usage:
  $ conv <anyOptions> <formatChar><num> <formatChar>
  Where <formatChar> is any of the supported formats and <num> is the number to convert

Supported Formats:
  Binary: 'b'
  Integer: 'i'
  Hex: 'x'

Other Options:
  --length, -l: Length to zero pad output (Only valid for non integer formats)
  --help, -h: Print this msg
  --version, -v: Print version

Examples:
  $ conv b0100101 i
  > 37

  $ conv i456 x
  > 1C9

  $ conv --length=3 i456 x
  > 1C9
""".strip()
