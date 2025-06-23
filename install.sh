#!/bin/bash
git clone  --branch 2025.06.13 --single-branch https://github.com/microsoft/vcpkg
cp -r ./ports/* ./vcpkg/ports/
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg install content-transfer-engine
