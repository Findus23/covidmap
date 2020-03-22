import json
import re

population_data = {}

with open("bevölkerung.csv") as f:
    next(f)
    for line in f:
        columns = line.split(";")
        name = columns[1]
        population = int(columns[2])
        population_sum = sum(map(int, columns[3:]))
        assert population_sum == population
        population_data[name] = population
print(len(population_data))
with open("Bezirke.js") as f:
    text = f.read()

text = text.replace("var dpBezirke = ", "").replace(";", "")

data = json.loads(text)
cases = {}
for d in data:
    cases[d["label"]] = d["y"]

export = {}
for name, count in cases.items():
    if name == "Gröbming":
        continue
    export[name] = {"pop": population_data[name], "cases": count}

relmin = min(e["cases"] / e["pop"] for e in export.values())
relmax = max(e["cases"] / e["pop"] for e in export.values())

absmin = 0
absmax = max(e["cases"] for e in export.values())

with open("SimpleData.js") as f:
    regex = r"LetzteAktualisierung = \"(.+)\";"
    text = f.read()
    res = re.search(regex, text)
    last_update = res.group(1)

with open("public/data.json", "w") as f:
    json.dump({
        "source": [
            "https://info.gesundheitsministerium.at/data/Bezirke.js",
            "https://info.gesundheitsministerium.at/data/SimpleData.js"
        ],
        "data": export,
        "relmin": relmin,
        "relmax": relmax,
        "absmin": absmin,
        "absmax": absmax,
        "lastUpdate": last_update
    }, f, indent=2)
