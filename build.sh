#!/bin/bash

us=false
clean=false

for arg in "$@"; do
  if [[ "$arg" == "--clean" ]]; then
    rm -fr build
    clean=true
  fi
  if [[ "$arg" == "--us" ]]; then
    us=true
  fi
done

if [ ! -d build ]; then
  mkdir build
fi

echo "BUILDING"
cd build && qmake ../ && make && cd ..
echo "BUILD COMPLETE"
./build/eta-keyboard show >/dev/null 2>&1 &

trap 'kill $PID 2>/dev/null; exit' INT TERM

PID=$!
echo "PRESS [ENTER] TO STOP KEYBOARD"
read
kill "$PID" 2>/dev/null

if [[ "$us" == true ]]; then
  echo "SET KEYBOARD LAYOUT TO US"
  setxkbmap us
fi
