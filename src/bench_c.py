import os
import csv
import sys
from codecarbon import OfflineEmissionsTracker

n = sys.argv[1]
bench_name = sys.argv[2]
num_executions = int(sys.argv[3])

csv_filename = "measurements_c.csv"
benchmark_path = "./benchmark/clbg_c/.tmp"
input_knucleotide = "./benchmark/clbg_c/fasta-output-1000000.txt"

for execution in range(1, num_executions + 1):
    tracker = OfflineEmissionsTracker(country_iso_code="PRT")

    print(f"Running execution {execution} of {num_executions}...")
    
    tracker.start()
    
    if bench_name == "Knucleotide":
        command = f"{benchmark_path}/{bench_name} < {input_knucleotide} {n}"
    else:
        command = f"{benchmark_path}/{bench_name} {n}"
        
    os.system(command)

    tracker.stop()

    data = tracker.final_emissions_data
    row = ["C", bench_name, n, data.duration, data.emissions, data.energy_consumed]

    with open(csv_filename, mode="a", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(row)