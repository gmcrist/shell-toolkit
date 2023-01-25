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

typeset -A colors
tput=$(which tput)
if [ $? -ne 0 ]; then
    colors=()
else
    colors=(
        # Normal / None
        [none]=$(tput sgr0)
        [reset]=$(tput sgr0)

        # Bold
        [b]=$(tput bold)
        [bx]=$(tput sgr0)

        # Underline
        [u]=$(tput smul)
        [ux]=$(tput rmul)

        # Italic
        [i]=$(tput sitm)
        [ix]=$(tput ritm)

        # Foreground Colors
        [black]=$(tput setaf 0)
        [red]=$(tput setaf 1)
        [green]=$(tput setaf 2)
        [orange]=$(tput setaf 3)
        [blue]=$(tput setaf 4)
        [purple]=$(tput setaf 5)
        [cyan]=$(tput setaf 6)
        [light_grey]=$(tput setaf 7)

        [dark_grey]=$(tput setaf 8)
        [light_red]=$(tput setaf 9)
        [light_green]=$(tput setaf 10)
        [yellow]=$(tput setaf 11)
        [light_blue]=$(tput setaf 12)
        [light_purple]=$(tput setaf 13)
        [light_cyan]=$(tput setaf 14)
        [white]=$(tput setaf 15)

        # Background Colors
        [bg_black]=$(tput setab 0)
        [bg_red]=$(tput setab 1)
        [bg_green]=$(tput setab 2)
        [bg_orange]=$(tput setab 3)
        [bg_blue]=$(tput setab 4)
        [bg_purple]=$(tput setab 5)
        [bg_cyan]=$(tput setab 6)
        [bg_light_grey]=$(tput setab 7)

        [bg_dark_grey]=$(tput setab 8)
        [bg_light_red]=$(tput setab 9)
        [bg_light_green]=$(tput setab 10)
        [bg_yellow]=$(tput setab 11)
        [bg_light_blue]=$(tput setab 12)
        [bg_light_purple]=$(tput setab 13)
        [bg_light_cyan]=$(tput setab 14)
        [bg_white]=$(tput setab 15)
    )
fi

export colors=${colors}
