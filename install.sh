#!/usr/bin/env bash
# Copyright 2021-2023 Greg Crist <gmcrist@gmail.com>
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

source ./shell-toolkit 2>/dev/null || {
    echo "shell-toolkit is required for installation"
    exit 1
}

declare -a install_items
declare -a rollback

install_items=(
    "shell-toolkit"
    "libstk"
)

function usage() {
    self=$(basename $0)
    echo "Shell Toolkit"
    echo ""
    echo "Usage: ${self} <DESTINATION>"
    echo ""
}

function install_stk() {
    if [ $# -lt 1 ]; then
        usage
        return 1
    fi

    dest=$1

    # check if the destination is a valid directory
    [ -d ${dest} ]
    log_passfail $? "Verifying '${dest}' is a valid directory"
    [ $? -eq 0 ] || exit 1

    # check if the destination is writable
    [ -w ${dest} ]
    log_passfail $? "Verifying '${dest}' is writable"
    [ $? -eq 0 ] || exit 1

    for item in ${install_items[@]}; do
        log_trace "Checking ${item}"

        if [ ! -e ${item} ]; then
            log_fail "'${item}' cannot be found"
            return 1
        fi

        if [ ! -r ${item} ]; then
            log_fail "'${item}' cannot be read"
            return 1
        fi

        if [ -e ${dest}/${item} ]; then
            log_fail "'${item}' already exists in destination '${dest}'"
            return 1
        fi

        _output=$(cp -R "${item}" "${dest}/" 2>&1)
        log_passfail $? "Installing '${item}'... ${_output}"
    done
}

install_stk $@
exit $?
