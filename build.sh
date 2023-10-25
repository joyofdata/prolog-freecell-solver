#!/bin/bash

rm freecell.pl
python3 freecell.py > freecell.pl

if [ -e freecell.pl ]
then
    python3 test.py
else
    echo "freecell.pl does not exist."
fi