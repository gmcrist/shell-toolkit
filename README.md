# Shell Toolkit

## Overview

Shell Toolkit is a library of useful functions, variables, and definitions to be used in bash scripting.


## Installation

Install 'shell-toolkit' and the library files into a location that can be sourced in your path.

```bash
./install /usr/local/bin
```

## Usage

Source the library into your script:

```bash
#!/bin/bash
source shell-toolkit
```

## Available Modules


Library of useful functions, variables, and definitions for bash scripting.

These files/functions have accumulated over the years when used in a variety of personal projects and now merged into a single library for better re-use and distribution.


## Console Utilities

[color.sh](libstk/color.sh) provides a set of definitions are used to help with text output/display on the terminal. Requires `tput` to function


## Network / Internet

[download.sh](libstk/download.sh) provides a set of functions for various network/internet related functions.


## Logging

[log.sh](libstk/log.sh) provides a set of functions for logging within shell scripts. Includes configuration to customize log messages, such as:
* Prefixed Labels
* Color formatting
* Enable/Disable based upon the log level

Supports the following log level definitions:
* Fatal
* Error
* Warning
* Notice
* Informational
* Debug


