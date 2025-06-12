-- N-body benchmark from benchmarks game
-- Output: the total energy of the system at two different time steps.
-- Original code by Mike Pall and Geoff Leyland, with modifications by Hugo Gualandi.

local function new_body(x, y, z, vx, vy, vz, mass)
    return {
        x = x,
        y = y,
        z = z,
        vx = vx,
        vy = vy,
        vz = vz,
        mass = mass,
    }
end

local function offset_momentum(bodies)
    local n = #bodies
    local px, py, pz = 0.0, 0.0, 0.0
    for i = 1, n do
        local bi = bodies[i]
        local bim = bi.mass
        px = px + (bi.vx * bim)
        py = py + (bi.vy * bim)
        pz = pz + (bi.vz * bim)
    end

    local sun = bodies[1]
    local solar_mass = sun.mass
    sun.vx = sun.vx - px / solar_mass
    sun.vy = sun.vy - py / solar_mass
    sun.vz = sun.vz - pz / solar_mass
end

local function advance(bodies, dt)
    local n = #bodies
    for i = 1, n do
        local bi = bodies[i]
        for j = i + 1, n do
            local bj = bodies[j]
            local dx = bi.x - bj.x
            local dy = bi.y - bj.y
            local dz = bi.z - bj.z

            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
            local mag = dt / (dist * dist * dist)

            local bjm = bj.mass * mag
            bi.vx = bi.vx - (dx * bjm)
            bi.vy = bi.vy - (dy * bjm)
            bi.vz = bi.vz - (dz * bjm)

            local bim = bi.mass * mag
            bj.vx = bj.vx + (dx * bim)
            bj.vy = bj.vy + (dy * bim)
            bj.vz = bj.vz + (dz * bim)
        end
    end
    for i = 1, n do
        local bi = bodies[i]
        bi.x = bi.x + dt * bi.vx
        bi.y = bi.y + dt * bi.vy
        bi.z = bi.z + dt * bi.vz
    end
end

local function advance_multiple_steps(nsteps, bodies, dt)
    for _ = 1, nsteps do
        advance(bodies, dt)
    end
end

local function energy(bodies)
    local n = #bodies
    local e = 0.0
    for i = 1, n do
        local bi = bodies[i]
        local vx, vy, vz = bi.vx, bi.vy, bi.vz
        e = e + (0.5 * bi.mass * (vx * vx + vy * vy + vz * vz))
        for j = i + 1, n do
            local bj = bodies[j]
            local dx = bi.x - bj.x
            local dy = bi.y - bj.y
            local dz = bi.z - bj.z
            local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
            e = e - ((bi.mass * bj.mass) / distance)
        end
    end
    return e
end

-- Constants
local PI = 3.141592653589793
local SOLAR_MASS = 4 * PI * PI
local DAYS_PER_YEAR = 365.24

-- Bodies in the solar system
local bodies = {
    -- Sun
    new_body(
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        SOLAR_MASS),
    -- Jupiter
    new_body(
        4.84143144246472090e+00,
        -1.16032004402742839e+00,
        -1.03622044471123109e-01,
        1.66007664274403694e-03 * DAYS_PER_YEAR,
        7.69901118419740425e-03 * DAYS_PER_YEAR,
        -6.90460016972063023e-05 * DAYS_PER_YEAR,
        9.54791938424326609e-04 * SOLAR_MASS),
    -- Saturn
    new_body(
        8.34336671824457987e+00,
        4.12479856412430479e+00,
        -4.03523417114321381e-01,
        -2.76742510726862411e-03 * DAYS_PER_YEAR,
        4.99852801234917238e-03 * DAYS_PER_YEAR,
        2.30417297573763929e-05 * DAYS_PER_YEAR,
        2.85885980666130812e-04 * SOLAR_MASS),
    -- Uranus
    new_body(
        1.28943695621391310e+01,
        -1.51111514016986312e+01,
        -2.23307578892655734e-01,
        2.96460137564761618e-03 * DAYS_PER_YEAR,
        2.37847173959480950e-03 * DAYS_PER_YEAR,
        -2.96589568540237556e-05 * DAYS_PER_YEAR,
        4.36624404335156298e-05 * SOLAR_MASS),
    -- Neptune
    new_body(
        1.53796971148509165e+01,
        -2.59193146099879641e+01,
        1.79258772950371181e-01,
        2.68067772490389322e-03 * DAYS_PER_YEAR,
        1.62824170038242295e-03 * DAYS_PER_YEAR,
        -9.51592254519715870e-05 * DAYS_PER_YEAR,
        5.15138902046611451e-05 * SOLAR_MASS),
}

-- Main function
local function main(N)
    N = N or 50000000
    offset_momentum(bodies)
    print(string.format("%0.9f", energy(bodies)))  -- Energy before steps
    advance_multiple_steps(N, bodies, 0.01)     -- Perform N steps
    print(string.format("%0.9f", energy(bodies)))  -- Energy after steps
end

-- Check for command-line argument
local N = tonumber(arg[1])  -- If provided, use the first argument as N, otherwise use the default 50000000

-- Run the main function with the command-line argument N
main(N)
