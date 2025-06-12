import os
import csv
import sys
from codecarbon import OfflineEmissionsTracker

lua_versions = {
    "./luas/lua-all/lua-5.3.0/lua": "Lua 5.3.0",
    "./luas/lua-all/lua-5.3.1/lua": "Lua 5.3.1",
    "./luas/lua-all/lua-5.3.2/lua": "Lua 5.3.2",
    "./luas/lua-all/lua-5.3.3/lua": "Lua 5.3.3",
    "./luas/lua-all/lua-5.3.4/lua": "Lua 5.3.4",
    "./luas/lua-all/lua-5.3.5/lua": "Lua 5.3.5",
    "./luas/lua-all/lua-5.3.6/lua": "Lua 5.3.6",
    "./luas/lua-all/lua-5.4.0/lua": "Lua 5.4.0",
    "./luas/lua-all/lua-5.4.1/lua": "Lua 5.4.1",
    "./luas/lua-all/lua-5.4.2/lua": "Lua 5.4.2",
    "./luas/lua-all/lua-5.4.3/lua": "Lua 5.4.3",
    "./luas/lua-all/lua-5.4.4/lua": "Lua 5.4.4",
    "./luas/lua-all/lua-5.4.5/lua": "Lua 5.4.5",
    "./luas/lua-all/lua-5.4.6/lua": "Lua 5.4.6",
    "./luas/lua-all/lua-5.4.7/lua": "Lua 5.4.7",
    "./luas/luajit/src/luajit": "Lua JIT",
    "./luas/luau/luau": "Luau",
    "./luas/lua-aot-5.4/src/luaot": "Lua AOT"
}

lua = sys.argv[1]
bench = sys.argv[2]
n = sys.argv[3]
bench_name = sys.argv[4]
num_executions = int(sys.argv[5])

csv_filename = "measurements.csv"

lua_version = lua_versions.get(lua, "Unknown Lua version")

for execution in range(1, num_executions + 1):
    tracker = OfflineEmissionsTracker(country_iso_code="PRT")

    print(f"Running execution {execution} of {num_executions}...")
    
    if lua_version == "Lua AOT":
          command = f"./luas/lua-all/lua-5.4.7/lua {bench_name} {n}"
    else:
          command = f"{lua} {bench} {n}"

    tracker.start()
    
    os.system(command)

    tracker.stop()

    data = tracker.final_emissions_data
    row = [lua_version, bench_name, n, data.duration, data.emissions, data.energy_consumed]

    with open(csv_filename, mode="a", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(row)