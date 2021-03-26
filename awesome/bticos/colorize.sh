#!/bin/bash
for f in */; do 
    cd $f
    convert blank.png -fuzz 100% -fill orange -opaque white middle.png
    convert blank.png -fuzz 100% -fill red -opaque white off.png
    convert blank.png -fuzz 100% -fill green -opaque white on.png
    cd ..
done
