#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

git submodule update --init --recursive

# Check out breakpad using the depot_tools
export PATH="$PWD/modules/depot_tools:$PATH"
mkdir modules/breakpad
cd modules/breakpad
fetch breakpad
cd src
git checkout 644e7159
