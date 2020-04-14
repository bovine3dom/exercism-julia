const WHITELIST = [' ','-'] # Characters which may be repeated

# This function operates in essentially constant time on real-ish words: 90 ns
# Most of this time (~70 ns) is spent initialising the Set.
function isisogram(s::AbstractString)
    seen = Set{Char}()
    for C in s
        c = lowercase(C) # Most words aren't isograms - this ensures we don't spend time lowercasing the whole string when we probably don't need to
        c ∈ seen && return false
        !(c in WHITELIST) && push!(seen,c)
    end
    true
end

# Lines below are interesting but require the StatsBase.jl and StaticArrays.jl packages

# # cmcaine patented technique
# # (ça ne marche pas pour les mots étrangers)
# #
# # ~5 times faster than above method for short real-ish words.
# # NB: all speedup comes from StaticArrays - a normal array makes it roughly the same speed as the function above.
# using StaticArrays
# function isisogram2(input)
#     counts = @MVector zeros(Int, 26)
#     @inbounds for c in codeunits(input)
#         if codepoint('a') <= c <= codepoint('z')
#             counts[c - codepoint('a')] += 1
#         elseif codepoint('A') <= c <= codepoint('Z')
#             counts[c - codepoint('A')] += 1
#         end
#         # Early return:
#         # This line makes the function operate in approx constant time for real-ish words, ~60 ns
#         # It is more performant without it for words < 50 characters.
#         # Longer words are unlikely to be pangrams anyway given that the alphabet has 26 characters.
# #       any(counts .> 1) && return false
#     end
#     all(counts .< 2)
# end
# 
# # For testing
# import StatsBase
# using BenchmarkTools
# const ALPHABET = 'a':'z' |> collect
# const WEIGHTS = [ # from https://www.wikipedia.org/wiki/Letter_frequency 
#  8.167e-2,
#  1.492e-2,
#  2.202e-2,
#  4.253e-2,
#  12.702e-2,
#  2.228e-2,
#  2.015e-2,
#  6.094e-2,
#  6.966e-2,
#  0.153e-2,
#  1.292e-2,
#  4.025e-2,
#  2.406e-2,
#  6.749e-2,
#  7.507e-2,
#  1.929e-2,
#  0.095e-2,
#  5.987e-2,
#  6.327e-2,
#  9.356e-2,
#  2.758e-2,
#  0.978e-2,
#  2.560e-2,
#  0.150e-2,
#  1.994e-2,
#  0.077e-2,
# ]
# randword(n) = [ALPHABET[StatsBase.sample(StatsBase.ProbabilityWeights(WEIGHTS))] for i in 1:n] |> join
# @benchmark isisogram(w) setup=(w=randword(10))
# @benchmark isisogram2(w) setup=(w=randword(10))
