#!/bin/bash

set -e
set -x

wget https://info.gesundheitsministerium.at/data/SimpleData.js
wget https://info.gesundheitsministerium.at/data/Bezirke.js
python3 main.py
rm SimpleData.js Bezirke.js
