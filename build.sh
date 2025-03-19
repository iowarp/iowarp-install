#!/bin/bash
. ./install.sh
cd ..
cp -r ./vcpkg/installed/x64-linux/* "${PREFIX}/"
pip install .


