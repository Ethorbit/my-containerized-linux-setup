#!/bin/bash
for i in "$@"; do
	if [ ! -L "$i" ]; then
		base=$(dirname "$i")
		mkdir -p "/volume/$base"
		mv "$i" "/volume/$i"
		ln -s "/volume/$i" "$i"
	fi
done
