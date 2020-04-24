const NUCLEOTIDES = ['C','G','A','T']

function count_nucleotides(strand::AbstractString)
    counts = zeros(Int,length(NUCLEOTIDES))
    l = Dict(v=>i for (i,v) in enumerate(NUCLEOTIDES))
    try
        for s in strand
            @inbounds counts[l[s]] += 1
        end
    catch(e)
        # If s is not a valid nucleotide
        isa(e,KeyError) && throw(DomainError(e))
        throw(e)
    end
    Dict(k=>counts[v] for (k,v) in l)
end

# This was my first attempt
# It doesn't throw domain errors and I couldn't work out how to do so without slowing it down a lot
#
# It's interesting that it's so fast even though it iterates through the list length(NUCLEOTIDES) times
#
# For large strings it's about 25% faster than the array based approach (thanks cmcaine for some optimisations)
function count_nucleotides_nosanitise(strand::AbstractString)
    Dict(n=>mapreduce(==(n),+,strand; init=0) for n in NUCLEOTIDES)
#   Dict(n=>sum(==(n),strand) for n in NUCLEOTIDES) # equivalent but less readable IMO
end

# ~#-real-cores speedup over the single-threaded one above (ta to cmcaine for pointing out codeunits for cheap conversion to array)
import ThreadsX
function count_nucleotides_threads(strand::AbstractString)
    Dict(Char(n)=>ThreadsX.mapreduce(==(n),+,codeunits(strand); init=0) for n in codeunits(join(NUCLEOTIDES)))
end

# GPU version
using CuArrays
# Getting data to the GPU is slow; this is approx 4x faster than the single threaded method
count_nucleotides_gpu(strand::String) = count_nucleotides_gpu(CuArray(codeunits(strand)))

# But once it's there we get a further 15x speedup (with a lowly 1080Ti)
count_nucleotides_gpu(strand::CuArray) = Dict(Char(n) => sum(==(n),strand) for n in codepoint.(NUCLEOTIDES))

# For testing
# using Random: randstring
# const s = randstring(NUCLEOTIDES,1_000_000_000);
# const c = codeunits(s);
# const d = CuArray(c);
# using BenchmarkTools
# @benchmark count_nucleotides(s)
# @benchmark count_nucleotides_threads(s)
# @benchmark count_nucleotides_gpu(d)
