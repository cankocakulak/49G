#!/bin/zsh
echo "Enter the MATLAB file to run (without extension):"
read filename
matlab -batch "run('$filename.m')"
