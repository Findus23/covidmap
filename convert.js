const fs = require("fs");
const path = require("path");
const topojson = require("topojson");


const contents = fs.readFileSync("STATISTIK_AUSTRIA_POLBEZ_20200101Polygon.json");
const geojson = JSON.parse(contents);

delete geojson.totalFeatures;
delete geojson.crs;
geojson.meta = {};
geojson.features.forEach((feature) => {
});

result = topojson.topology({districts: geojson}, 1e5);
result = topojson.presimplify(result);
// result = topojson.simplify(result, 1e-9);
// result = topojson.quantize(result, 1e4);
result = topojson.filter(result, topojson.filterWeight);

fs.writeFileSync("public/map.topo.json", JSON.stringify(result));
