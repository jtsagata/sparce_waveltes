#!/bin/bash

while true; do inotifywait -e modify *.tex; rubber -d WaveletReport.tex; done
