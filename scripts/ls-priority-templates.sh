#!/bin/bash

rg --color="never" --no-line-number '^- ' doc/MAINTENANCE.md \
  | sed 's/^-\s//' \
  | sort
