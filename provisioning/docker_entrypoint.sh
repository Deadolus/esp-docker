#!/bin/bash

export PATH="$PATH:$HOME/esp/xtensa-esp32-elf/bin"
export IDF_PATH=~/esp/esp-idf
ln -s /projects ~/projects

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="/bin/bash"
fi

exec $args
