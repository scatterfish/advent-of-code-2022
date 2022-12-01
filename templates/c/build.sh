#!/bin/sh

mkdir -p out
if gcc main.c -o out/main; then
	exec ./out/main
fi
