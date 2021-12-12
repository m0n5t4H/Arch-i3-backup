#!/bin/sh
case "$1" in
    --popup)
        dunstify -a App "Memory (%)" "$(ps axch -o cmd:10,pmem k -pmem | head | awk '$0=$0"%"' )"
        ;;
    *)
        echo ""
        ;;
esac
