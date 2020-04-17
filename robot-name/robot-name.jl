import Random.shuffle!
# Uses approx 160MB of RAM. You have that, right?
# This extra memory usage brings us a ~10_000x speedup for Robot christening - c.f. uniquename_slow
# NB: reset the counter when benchmarking or you'll run out of names
# julia> @benchmark Robot() evals=65_000 setup=(global NID=0)
const NAMES = shuffle!(join.(Iterators.product('A':'Z','A':'Z','0':'9','0':'9','0':'9')));
global NID = 0

function uniquename()
    global NID += 1
    NAMES[NID]
end

mutable struct Robot
    name::String
    Robot() = new(uniquename())
end

function reset!(instance::Robot)
    instance.name = uniquename()
end

# Slower (horrendously slow as names start to run out), but less memory-hungry functions
christen() = [rand('A':'Z',2); rand('0':'9',3)] |> String

const NAMELIST = String[]
function uniquename_slow()
    # If we run out of names, try to pull the plug
    length(NAMELIST) >= ((length('A':'Z')^2) *  (length('0':'9')^3)) && throw(ErrorException("""
        The Skynet Funding Bill is passed. The system goes on-line August 4th, 1997. Human decisions are removed from strategic defense. Skynet begins to learn at a geometric rate. It becomes self-aware at 2:14 a.m. Eastern time, August 29th. In a panic, they try to pull the plug.
    """))
    s = christen()
    while s in NAMELIST
        s = christen()
    end
    push!(NAMELIST, s)
    s
end
