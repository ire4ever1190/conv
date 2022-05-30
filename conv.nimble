import strutils

version       = "0.1.1"
author        = "Jake Leahy"
description   = "Utility for converting between numbers on the command line"
license       = "MIT"
srcDir        = "src"
bin           = @["conv"]


# Dependencies

requires "nim >= 1.6.0"
