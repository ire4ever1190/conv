Simple CLI ultility for converting between different number formats (Currently supports integer/hex/binary).
Mainly made because I kept needing to use random websites when converting numbers and it was getting annoying

### Installation

```
nimble install https://github.com/ire4ever1190/conv
```


##### Basic usage:
```console
$ conv <anyOptions> <formatChar><num> <formatChar>
```
Where <formatChar> is any of the supported formats and <num> is the number to convert

##### Supported Formats:
  - Binary: 'b'
  - Integer: 'i'
  - Hex: 'x'

##### Other Options:
  - `--length`, `-l`: Length to zero pad output (Only valid for non integer formats)
  - `--help`, `-h`: Print this msg
  - `--version`, `-v`: Print version

##### Examples:
```console
$ conv b0100101 i
37

$ conv i456 x
1C9

$ conv --length=3 i456 x
1C9
```
