#!/bin/bash
. ./install.sh
cd ..
cp -r /home/runner/work/iowarp-install/iowarp-install/vcpkg/installed/x64-linux/* "${PREFIX}/"
pip install .


