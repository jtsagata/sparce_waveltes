#!/bin/bash

pushd ../Report
for a in *.png; do convert -trim "$a" "$a"; done

popd
rm *.aux *.log *.out
rubber -d WaveletReport.tex

while true; do inotifywait -e modify *.tex; rubber -d WaveletReport.tex; done
