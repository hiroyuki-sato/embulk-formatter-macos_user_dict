# macOS User Dictionary formatter plugin for Embulk

macOS User Dictionary formatter plugin for Embulk

## Overview

* **Plugin type**: formatter

## Configuration

- **phrase_column**: phrase colum name (string, default: `"phrase"`)
- **shortcut_column**: shortcut column name (string, default: `"shortcut"`)

## Example

```yaml
in:
  type: file
  path_prefix: dict.txt
  parser:
    charset: UTF-8
    newline: CRLF
    type: csv
    delimiter: ','
    quote: '"'
    escape: '"'
    trim_if_not_quoted: false
    skip_header_lines: 1
    allow_extra_columns: false
    allow_optional_columns: false
    columns:
    - {name: phrase, type: string}
    - {name: shortcut, type: string}
out:
  type: file
  path_prefix: dict.
  file_ext: plist
  formatter:
    type: macos_user_dict


exec:
  max_min_output: 1
```


## Build

```
$ rake
```
