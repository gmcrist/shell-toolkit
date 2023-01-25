#!/usr/bin/env bash
# Copyright 2020-2023 Greg Crist <gmcrist@gmail.com>
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

# Import log
if [ -f ${source_path}/log.sh ]; then
    source ${source_path}/log.sh
fi

# Downloads a file from a specified source URL and saves to the
# specified file
# @param src  - source URL
# @param dest - destination path/filename
# @return return code from download program or non-zero on other error
# @notes Will attempt to use curl (if installed) and fall back to using
#        wget (if installed) if neither are installed, it will return an
#        error
function download() {
    if [ $# -ne 2 ]; then
        return 2
    fi

    src=$1
    dest=$2

    # Attempt to use curl first
    curl=$(which curl)
    if [ $? -eq 0 ]; then
        _output=$(${curl} -f --silent --show-error -o ${dest} ${src} 2>&1)
        log_auto $? ${_output}
        return $?
    fi

    # Fallback to wget
    wget=$(which wget)
    if [ $? -eq 0 ]; then
        _output=$(${wget} -q -O ${dest} ${src} 2>&1)
        log_auto $? ${_output}
        return $?
    fi

    # return an error if we don't have curl or wget
    return 1
}

