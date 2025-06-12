-- k-nucleotide norm benchmark from benchmarks game

local function read_input(f)
    for line in f:lines() do
        if string.sub(line, 1, 6) == ">THREE" then
            break
        end
    end
    local lines = {}
    for line in f:lines() do
        table.insert(lines, line)
    end
    return string.upper(table.concat(lines))
end

local function compute_freqs(seq, length)
    local freqs = setmetatable({}, { __index = function() return 0 end })
    local n = #seq - length + 1
    for f = 1, length do
        for i = f, n, length do
            local s = string.sub(seq, i, i + length - 1)
            freqs[s] = freqs[s] + 1
        end
    end
    return n, freqs
end

local function sort_by_freq(seq, length)
    local n, freq = compute_freqs(seq, length)

    local seqs = {}
    for k, _ in pairs(freq) do
        seqs[#seqs + 1] = k
    end

    table.sort(seqs, function(a, b)
        local fa, fb = freq[a], freq[b]
        return (fa == fb) and (a < b) or (fa > fb)
    end)

    for _, c in ipairs(seqs) do
        io.write(string.format("%s %0.3f\n", c, freq[c] * 100 / n))
    end
    io.write("\n")
end

local function single_freq(seq, s)
    local _, freq = compute_freqs(seq, #s)
    io.write(freq[s], "\t", s, "\n")
end

-- Main logic
local N = tonumber(arg[1]) or 100
local filename = "./benchmark/fasta-output-" .. tostring(N) .. ".txt"

local f, err = io.open(filename, "r")
if not f then
    io.stderr:write("Error opening file: " .. err .. "\n")
    os.exit(1)
end

local seq = read_input(f)
f:close()

sort_by_freq(seq, 1)
sort_by_freq(seq, 2)

single_freq(seq, "GGT")
single_freq(seq, "GGTA")
single_freq(seq, "GGTATT")
single_freq(seq, "GGTATTTTAATT")
single_freq(seq, "GGTATTTTAATTTATAGT")
