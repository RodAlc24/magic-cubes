#! /bin/env bash

for file in *.typ; do
    typst c -f svg "$file"
done
