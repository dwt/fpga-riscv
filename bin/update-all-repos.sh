#! /bin/sh

find . -mindepth 2 -maxdepth 2 -name .git -type d -exec git -C {}/.. pull \;
