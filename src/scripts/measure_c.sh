#!/bin/bash

EXECUTION_TIMES=10

BENCHMARK_PATH=./benchmark/clbg_c
OUT=./benchmark/clbg_c/.tmp

if [ ! -d "./$OUT" ]; then
  mkdir -p ./$OUT
fi

COMPILE=(
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/binarytrees.c -o $OUT/BinaryTrees"
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/fannkuch.c -o $OUT/Fannkuch"
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/fasta.c -o $OUT/Fasta"
	"gcc-14 -fopenmp -O3 $BENCHMARK_PATH/knucleotide.c -o $OUT/Knucleotide"
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/mandelbrot.c -o $OUT/Mandelbrot"
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/nbody.c -o $OUT/Nbody"
	"gcc -O3 -fomit-frame-pointer -funroll-loops $BENCHMARK_PATH/spectralnorm.c -o $OUT/Spectralnorm"
)

for CMD in "${COMPILE[@]}"; do
  $CMD
done

BENCHMARKS=(
  "16 BinaryTrees"
  "11 Fannkuch"
  "2500000 Fasta"
  "1000000 Knucleotide"
  "4000 Mandelbrot"
  "5000000 Nbody"
  "4000 Spectralnorm"
)

echo "language,benchmark,input,duration,emissions,energy_consumed" > measurements_c.csv

for bench_line in "${BENCHMARKS[@]}"; do
    read -r input_arg bench_name <<< "$bench_line"
    python3 bench_c.py "$input_arg" "$bench_name" "$EXECUTION_TIMES"
done

# # Cleanup

rm -f emissions.csv
rm -f powermetrics_log.txt
rm -rf $OUT