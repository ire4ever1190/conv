import std/unittest
import std/osproc
import std/os
import std/strutils
import ../src/conv {.all.}

const 
  rootFolder = currentSourcePath().parentDir.parentDir
  intBits = sizeof(int) * 8


template checkOut(cmd: string, expected: string, code = 0) =
  let (output, exitCode) = execCmdEx(
    cmd,
    workingDir=rootFolder/"tests"
  )
  check:
    output.strip() == expected.strip()
    exitCode == code

test "Build binary":
  let (_, exitCode) = execCmdEx(
    "nim c --gc:arc -f --out:tests/conv src/conv.nim",
    workingDir=rootFolder
  )
  require exitCode == 0

test "Help Message":
  checkOut("./conv --help", helpMsg)
  checkOut("./conv -h", helpMsg)

test "Version":
  checkOut("./conv --version", version)
  checkOut("./conv -v", version)

# These next three suites are pretty useless but says me having to manually test
# in the beginning. If I add more formats then I'll just check they convert to
# integers properly

suite "Integer":
  template toForm(num: int, fun: proc): string =
    num.fun(intBits).strip(chars = {'0'}, trailing=false)
  
  test "Integer to integer":
    checkOut("./conv i6368 i", "6368")

  test "Integer to binary":
    checkout("./conv i598 b", 598.toForm(toBin))

  test "Integer to hex":
    checkout("./conv i234 x", 234.toForm(toHex))


suite "Binary":
  test "Binary to integer":
    checkOut("./conv b11101 i", "29")

  test "Binary to binary":
    checkOut("./conv b01101 b", "1101")

  test "Binary to hex":
    checkOut("./conv b111111011100011 x", "7EE3")

suite "Hex":
  test "Hex to integer":
    checkOut("./conv x7EE3 i", "32483")

  test "Hex to binary":
    checkOut("./conv x1234A b", "10010001101001010")

  test "Hex to hex":
    checkOut("./conv x456EB x", "456EB")

suite "Different flags":
  test "Length":
    checkOut("./conv --length=16 b1 b", "0000000000000001")

suite "Error messages":
  test "Input is in wrong format":
    checkOut("./conv xj i", "Input is not in hex format", 1)
    checkOut("./conv ik i", "Input is not in integer format", 1)
    checkOut("./conv b921 x", "Input is not in binary format", 1)

  test "Missing input format":
    checkOut("./conv", "Input format not specified", 1)

  test "Missing output format":
    checkOut("./conv xFF", "Output format not specified", 1)

  test "Missing input value":
    checkOut("./conv x i", "Input value is not provided", 1)
    
  test "Input value is partially correct":
    checkOut("./conv i1234j b", """
Input is not fully in integer format: 1234j
                                          ^""", 1)
