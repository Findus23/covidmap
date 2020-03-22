#!/bin/bash

set -e
set -x

yarn install
mkdir public/libs || true
cp node_modules/d3/dist/d3.js public/libs
cp node_modules/d3-svg-legend/d3-legend.js public/libs
cp node_modules/topojson-client/dist/topojson-client.js public/libs

rm -r tmp || true
mkdir tmp
# shellcheck disable=SC2164
cd tmp

wget "https://www.statistik.at/wcm/idc/idcplg?IdcService=GET_NATIVE_FILE&RevisionSelectionMethod=LatestReleased&dDocName=059037" -O statistik.zip
unzip statistik.zip
iconv -f ISO-8859-15 -t UTF-8 daten_popreg.v_agesex_polbez_de.csv > ../bevölkerung.csv


wget https://data.statistik.gv.at/data/OGDEXT_POLBEZ_1_STATISTIK_AUSTRIA_20200101.zip
unzip OGDEXT_POLBEZ_1_STATISTIK_AUSTRIA_20200101.zip
# shellcheck disable=SC2103
cd ..
./node_modules/mapshaper/bin/mapshaper tmp/STATISTIK_AUSTRIA_POLBEZ_20200101Polygon.shp -proj wgs84 -simplify 5% -o public/map.json format=topojson bbox
./update.sh
