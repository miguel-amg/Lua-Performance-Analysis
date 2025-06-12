#!/bin/bash

# List of Lua interpreters
LUAS=(
  ./luas/lua-all/lua-5.3.0/lua
  ./luas/lua-all/lua-5.3.1/lua
  ./luas/lua-all/lua-5.3.2/lua
  ./luas/lua-all/lua-5.3.3/lua
  ./luas/lua-all/lua-5.3.4/lua
  ./luas/lua-all/lua-5.3.5/lua
  ./luas/lua-all/lua-5.3.6/lua
  ./luas/lua-all/lua-5.4.0/lua
  ./luas/lua-all/lua-5.4.1/lua
  ./luas/lua-all/lua-5.4.2/lua
  ./luas/lua-all/lua-5.4.3/lua
  ./luas/lua-all/lua-5.4.4/lua
  ./luas/lua-all/lua-5.4.5/lua
  ./luas/lua-all/lua-5.4.6/lua
  ./luas/lua-all/lua-5.4.7/lua
)

# Other interpreters 
LUA_JIT=./luas/luajit/src/luajit
LUAU=./luas/luau/luau
LUAAOT=./luas/lua-aot-5.4/src/luaot

EXECUTION_TIMES=10

BENCHMARKS=(
  "./benchmark/binarytrees.lua 16 BinaryTrees"
  "./benchmark/fannkuch.lua 11 Fannkuch"
  "./benchmark/fasta.lua 2500000 Fasta"
  "./benchmark/knucleotide.lua 1000000 Knucleotide"
  "./benchmark/mandelbrot.lua 4000 Mandelbrot"
  "./benchmark/nbody.lua 5000000 Nbody"
  "./benchmark/spectralnorm.lua 4000 Spectralnorm"
)

BENCHMARKS_JIT=(
  "./benchmark/binarytrees_jit.lua 16 BinaryTrees"
  "./benchmark/fannkuch.lua 11 Fannkuch"
  "./benchmark/fasta_jit.lua 2500000 Fasta"
  "./benchmark/knucleotide.lua 1000000 Knucleotide"
  "./benchmark/mandelbrot_jit.lua 4000 Mandelbrot"
  "./benchmark/nbody.lua 5000000 Nbody"
  "./benchmark/spectralnorm.lua 4000 Spectralnorm"
)

echo "lua,benchmark,input,duration,emissions,energy_consumed" > measurements.csv

######################################## Lua interpreters benchmark ########################################

for lua in "${LUAS[@]}"; do
  for bench_line in "${BENCHMARKS[@]}"; do
    read -r bench_script input_arg bench_name <<< "$bench_line"
    python3 bench.py "$lua" "$bench_script" "$input_arg" "$bench_name" "$EXECUTION_TIMES"
  done
done

############################################# LuaJIT benchmark ############################################

for bench_line in "${BENCHMARKS_JIT[@]}"; do
    read -r bench_script input_arg bench_name <<< "$bench_line"
    python3 bench.py "$LUA_JIT" "$bench_script" "$input_arg" "$bench_name" "$EXECUTION_TIMES"
done

# ############################################## Luau benchmark #############################################

# for bench_line in "${BENCHMARKS[@]}"; do
#     read -r bench_script input_arg bench_name <<< "$bench_line"
#     python3 bench.py "$LUAU" "$bench_script" "$input_arg" "$bench_name" "$EXECUTION_TIMES"
# done

############################################# LuaAOT benchmark ############################################

# Doesn't work with arm64

# mkdir -p .tmp
# mkdir -p aot

# for bench_line in "${BENCHMARKS[@]}"; do
#     read -r bench_script input_arg bench_name <<< "$bench_line"

#     "$LUAAOT" "$bench_script" -o "./aot/${bench_name}.c"
#     gcc -shared -fPIC -O2 -I./luas/lua-aot-5.4/src -v "./aot/${bench_name}.c" -o "./.tmp/${bench_name}.so"

# 	python3 bench.py "$LUAAOT" "$bench_script" "$input_arg" "$bench_name" "$EXECUTION_TIMES"
# done

# # Cleanup

# rm -rf aot
# rm -rf .tmp

###########################################################################################################

# Cleanup

rm -f emissions.csv
rm -f powermetrics_log.txt