const ALPHABET = "abcdefghijklmnopqrstuvwxyz" |> collect
const WEIGHTS = [ # from https://www.wikipedia.org/wiki/Letter_frequency 
 8.167e-2,
 1.492e-2,
 2.202e-2,
 4.253e-2,
 12.702e-2,
 2.228e-2,
 2.015e-2,
 6.094e-2,
 6.966e-2,
 0.153e-2,
 1.292e-2,
 4.025e-2,
 2.406e-2,
 6.749e-2,
 7.507e-2,
 1.929e-2,
 0.095e-2,
 5.987e-2,
 6.327e-2,
 9.356e-2,
 2.758e-2,
 0.978e-2,
 2.560e-2,
 0.150e-2,
 1.994e-2,
 0.077e-2,
]
s = [ALPHABET[StatsBase.sample(StatsBase.ProbabilityWeights(WEIGHTS))] for i in 1:1000] |> join

 
# NB: a pangram is technically a _sentence_ which contains all the letters of the alphabet. I have decided to ignore this as detecting the end of sentences (e.g. ignoring e.g.) seems more like a machine-learning problem.

function ispangram(input::AbstractString)
    # `lowercase` is expensive in time and memory for large strings, so we avoid it by checking against lower and uppercase characters
    all(occursin(c,input) || occursin(uppercase(c),input) for c in ALPHABET)
end


# In most cases where there is a pangram, this is slower than the above code.
# If there isn't a pangram, and the string is big, it's ~nproc faster.
#
# Since this exercise is about detecting pangrams, it's fair to say that there is a reasonable likelihood that the strings being tested are a) pangrams and b) short, as they are sentences. So the previous code is better.
#
# It's a nice demonstration that the real-world performance of code depends on the type of input you are expecting.
import ThreadsX
function ispangramthreads(input::AbstractString)
    ThreadsX.mapreduce(c->occursin(c,input),&,ALPHABET)
#    ThreadsX.all(c->occursin(c,input),ALPHABET) # this appears to be single threaded
end

# Variant of above with early stopping; it's still slower than the initial code for most pangrams. Probably due to the overhead of threads:
# ```
# julia> @btime ispangramthreads_earlystop($(""))
#   10.229 μs (179 allocations: 20.00 KiB)
# false
# 
# julia> @btime ispangramthreads_earlystop($s) # 10 million character random alphabetic string
#   10.624 μs (213 allocations: 20.53 KiB)
#  true
# ```
#
# ```
# julia> [begin; r = repeat("1",n)*(ALPHABET|>join); (n, (@elapsed ispangram(r)) > (@elapsed ispangramthreads_earlystop(r)) ? "multi-threaded is faster" : "single threaded i
# s faster"); end for n in 10 .^ (1:8)]
# 8-element Array{Tuple{Int64,String},1}:
#  (10, "single threaded is faster")      
#  (100, "single threaded is faster")     
#  (1000, "single threaded is faster")    
#  (10000, "single threaded is faster")   
#  (100000, "single threaded is faster")  
#  (1000000, "single threaded is faster") 
#  (10000000, "multi-threaded is faster") 
#  (100000000, "multi-threaded is faster")
# ```
# So, it's faster if you expect 10_000_000 characters before you have a pangram, which is a little longer than most sentences.
function ispangramthreads_earlystop(input::AbstractString)
    tasks = Array{Task,1}()
    foreach(c->push!(tasks,Threads.@spawn occursin(c,input) || occursin(uppercase(c),input)),ALPHABET)

    # This feels like it should be a common pattern: operate on data as soon as it comes through with an early exit if we can.
    # Perhaps channels are the way forward. `try while isready || isopen; take; end; catch; isa(InvalidStateException)`?
    while any(t->!istaskdone(t),tasks)
        any(t->istaskdone(t) && !t.result, tasks) && return false
    end
    # Check the last task
    any(t->istaskdone(t) && !t.result, tasks) && return false
    return true
end

using StaticArrays: @MVector
#
function ispangram3(input)
    # This creates a 26 byte static array. The compiler is able to reason that
    # it does not escape this function, so it gets stack allocated despite
    # being mutable, which is neat.
    present = @MVector zeros(Bool, 26)
    @inbounds for i in 1:ncodeunits(input)
        c = codeunit(input, i)
        if 0x61 <= c <=  0x7a
            present[c - 0x60] = true
        elseif 0x41 <= c <= 0x5a
            present[c - 0x40] = true
        end
    end
    all(present)
end

