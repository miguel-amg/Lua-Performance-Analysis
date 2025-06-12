# On The Performance Of Lua

**Authors:** André Brandão [(Github)](https://github.com/brandao07), Diogo Matos [(Github)](https://github.com/diogogmatos), Miguel Guimarães [(Github)](https://github.com/miguel-amg).

**University of Minho** - Masters Degree in Software Engineering.

**Description:** This repository contains the data and scripts used to evaluate Lua’s performance, specifically its energy consumption and execution time.

![Logo](assets/uminho.jpg)

***

# Compilers and versions
The compilers selected for this study were:

- The official Lua compiler, covering versions from 5.3.0 to 5.4.7.
- The LuaJIT compiler, version 2.1.

# Benchmarks
As for the benchmarks themselves we adapted the suite provided by [LuaAOT](https://github.com/hugomg/lua-aot-5.4), which has been widely used in previous performance studies.

These were the selected benchmarks:

- Binary Trees
- Fannkuch
- Fasta
- Knucleotide
- Mandelbrot
- Nbody
- Spectralnorm

# Research details
The machine used to perform this study had the following specifications:
- **Operating System:** macOS 15.3.2 (24D81) arm64
- **Kernel:** 24.3.0
- **CPU:** Apple M1
- **GPU:** Apple M1
- **RAM:** 16 GB
- **Host:** MacBookPro17,1

Due to incompatibilities with macOS, this research only used only two of the proposed compilers.

The Luau, LuaAOT and luaJIT-remake were scraped as a result of this incompatibility.

# Src folder
The src folder contains a makefile that is responsible for executing the following steps:
- ```make install``` - Install all lua compilers and versions.
- ```make download``` - Cleans up previous files, downloads new ones, and performs a light cleanup.
- ```make full-cleanup``` - Removes all generated or temporary files for a fresh start.
- ```make measure``` - Runs the measurement script.
- ```make help``` - Shows a help message.

**Requirements:** Codecarbon.

# Analysis folder
The analysis folder contains:
- The raw data measured from our research using the scripts in the Src folder.
- The python file ```data_analysis.ipynb``` used in the creation of the graphs.

**Requirements:** matplotlib, pandas, seaborn, ipykernel.

***

## References
 - [The Lua Programming Language](https://www.lua.org/)

 - [LuaJIT: Just-In-Time Compiler for Lua](https://luajit.org/)

 - [Lua-aot-5.4: AOT compiler for Lua 5.4](https://github.com/hugomg/lua-aot-5.4)

 - [Luau: A fast, small, safe, gradually typed embeddable scripting language derived from Lua](https://luau.org/)


 - [LuaJIT-Remake](https://github.com/luajit-remake/luajit-remake)

 - [GPS-UP: A Better Metric for Comparing Software Energy Efficiency](https://greensoftware.foundation/articles/gps-up-a-better-metric-for-comparing-software-energy-efficiency)

 
 - [CodeCarbon Methodology](https://mlco2.github.io/codecarbon/methodology.html)
 
