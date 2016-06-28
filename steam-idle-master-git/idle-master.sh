#!/bin/bash
bin=idle-master
config=${XDG_CONFIG_HOME:-$HOME/.config}/$bin
run=${XDG_RUNTIME_DIR:-/tmp}/$bin

for dir in "$config" "$run" ; do
	[[ ! -d $dir ]] && mkdir -p "$dir"
done

mountpoint "$run" -q || unionfs "$config=RW:/usr/share/$bin=RO" "$run"

python2 "$run/start.py"

fusermount -u "$run"
