#!/bin/bash

MAIN_TEX=WaveletReport

function control_c {
    echo -en "\n## Caught SIGINT; Clean up and Exit \n"
    rubber --clean ${MAIN_TEX}.tex
    exit
}

trap control_c SIGINT
trap control_c SIGTERM

pushd ../Report
for a in *.png; do convert -trim "$a" "$a"; done

popd

echo "Cleanup"
rubber --clean ${MAIN_TEX}.tex

echo "Build"
rubber -d WaveletReport.tex

while true; do 
    inotifywait -e modify *.tex; 
    rubber -d ${MAIN_TEX}.tex; 
    echo "Rebuild Done"
    sleep 2
done
