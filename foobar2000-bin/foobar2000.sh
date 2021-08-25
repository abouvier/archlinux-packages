#!/bin/bash
bin=foobar2000
opts=(/immediate)
data=${XDG_DATA_HOME:-$HOME/.local/share}/$bin
run=${XDG_RUNTIME_DIR:-/tmp}/$bin

install -d "$data" "$run"

mountpoint -q "$run" || unionfs -o noatime "$data=RW:/usr/share/$bin=RO" "$run"

case $1 in
	--pause | --playpause | --prev | --next | --rand | --stop | --exit | --show | --hide) ;&
	--play) wine "$run/$bin.exe" "/${1:2}" ;;
	--add) opts+=(/add) ;&
	--) shift ;&
	*) winepath -w0 -- "$@" | xargs -0 wine "$run/$bin.exe" "${opts[@]}" ;;
esac

pidof "$bin.exe" > /dev/null || fusermount -u -z "$run"
