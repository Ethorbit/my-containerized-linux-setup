#!/bin/bash
for i in "$@"; do
	if [ ! -L "$i" ]; then
		base=$(dirname "$i")
		mkdir -p "/volume/$base"
		cp -rapn "$i" "/volume/$i"
		rm -dr "$i"
		ln -s "/volume/$i" "$i"
	fi
done

