#!/bin/bash

mkdir dir
echo hello world >> dir/file
echo my name is roxma >>dir>file
mkdir dir/subdir
echo hello >>dir/subdir/fie2

set -x

grep hello *

grep hello dir/file

grep -r hello ./


set +x
echo "begin clean ..."
rm -r dir

