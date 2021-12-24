#!/bin/bash
# Copyright 2010-2014,2021 Greg Crist <gmcrist@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Get the current path to be able to source dependent files
source_path=$(dirname ${BASH_SOURCE})

# Import colors (if found) otherwise provide a placeholder
if [ -f ${source_path}/colors.sh ]; then
    source ${source_path}/colors.sh
else
    typeset -A colors
    colors=()
fi

typeset -A _log_config
_log_config=(
    ##
    # Log level enable/disable

    # Logs are enabled for all levels by default unless configured otherwise
    [enable.trace]=0
    [enable.debug]=0

    ##
    # Timestamp configuration

    # Disabled by default
    [timestamp]=0

    # Timestamp format (passed to 'date')
    [timestamp.format]="[%Y-%m-%d %H:%M:%S] "

    # Timestamps, if enabled, are enabled for all levels unless configured
    # otherwise
    [timestamp.enable.pass]=0
    [timestamp.enable.fail]=0

    ##
    # Label configuration

    # Enabled by default
    [labels]=1

    # Label prefixes per level
    [labels.trace]="TRACE: "
    [labels.debug]="DEBUG: "
    [labels.info]="INFO: "
    [labels.warn]="WARN: "
    [labels.error]="ERROR: "
    [labels.fatal]="FATAL: "

    [labels.pass]="[PASS]${colors[none]} "
    [labels.fail]="[FAIL]${colors[none]} "

    ##
    # Color Configuration

    # Colors are enabled by default
    [colors]=1

    # Each level may have it's own color configuration
    [colors.trace]=${colors[dark_grey]}
    [colors.debug]=${colors[light_grey]}
    [colors.info]=${colors[none]}
    [colors.warn]=${colors[orange]}
    [colors.error]=${colors[red]}
    [colors.fatal]=${colors[b]}${colors[red]}

    [colors.pass]=${colors[green]}
    [colors.fail]=${colors[red]}
)
export _log_config=${_log_config}

# Generic logging function
# @param level - the log level/type, used to supply labels/colors if provided
# @param ...   - text to be logged
function log_generic() {
    level=$1
    shift

    # Return if there is nothing to actually log
    if [ $# -eq 0 ]; then
        return
    fi

    # Return if the specified log level is not enabled
    if [ ${_log_config[enable.${level}]-1} -ne 1 ]; then
        return
    fi

    local log_prefix=""

    if [ ${_log_config[labels]-0} -eq 1 ]; then
        log_prefix=${_log_config[labels.${level}]}
    fi

    if [ ${_log_config[colors]-0} -eq 1 ]; then
        log_prefix="${_log_config[colors.${level}]}${log_prefix}"
    fi

    if [ ${_log_config[timestamp]-0} -eq 1 ]; then
        if [ ${_log_config[timestamp.enable.${level}]-1} -ne 0 ]; then
            timestamp=$(date "+${_log_config[timestamp.format]}")
            log_prefix="${timestamp}${log_prefix}"
        fi
    fi

    while IFS= read -r line; do
        echo -e "${log_prefix}${line}${colors[none]}"
    done <<< "$@"
}

# Automatic logging function: info/error
# @param errno - the error code indicating success or failure to determine
#                which logging function to use
# @param ...   - text to be logged
# @notes A "success" will use the "log_info" function
#        A "failure" will use the "log_error" function
function log_auto() {
    if [ $# -eq 0 ]; then
        return
    fi

    err=$1
    shift

    if [ ${err} -eq 0 ]; then
        log_info "$@"
    else
        log_error "$@"
    fi

    return ${err}
}

# Automatic logging function: pass/fail
# @param errno - the error code indicating pass or fail to determine which
#                logging function to use
# @param ...   - text to be logged
# @notes A "pass" will use the "log_pass" function / level
#        A "fail" will use the "log_fail" function / level
function log_passfail() {
    if [ $# -eq 0 ]; then
        return
    fi

    err=$1
    shift

    if [ ${err} -eq 0 ]; then
        log_pass "$@"
    else
        log_fail "$@"
    fi

    return ${err}
}

# Unspecified log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log() {
    log_generic "?" "$@"
}

# Log as a "trace" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_trace() {
    log_generic "trace" "$@"
}

# Log as a "debug" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_debug() {
    log_generic "debug" "$@"
}

# Log as a "info" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_info() {
    log_generic "info" "$@"
}

# Log as a "warn" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_warn() {
    log_generic "warn" "$@"
}

# Log as a "error" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_error() {
    log_generic "error" "$@"
}

# Log as a "fatal" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_fatal() {
    log_generic "fatal" "$@"
}

# Log as a "pass" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_pass() {
    log_generic "pass" "$@"
}

# Log as a "fail" log level
# @param ... - text to be logged
# @notes This is a wrapper around the log_generic function
function log_fail() {
    log_generic "fail" "$@"
}

