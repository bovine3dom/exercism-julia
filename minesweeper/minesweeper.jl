# function annotate(minefield::Array{<:AbstractString,1}) # Sensible IMO but fails the first test
function annotate(minefield::Vector)
    isempty(minefield) && return minefield
    
    # Julia gets upset / slow here as matrix can be Array{,2} or Array{,1}
    # TODO: work out how to ensure it is always Array{,2} for hopeful speedup
    matrix = map(x->x=='*',mapreduce(collect,hcat,minefield))  # |> permutedims |> permutedims (this is a crazy way of doing this)
    flagged = flag_mines(matrix)
    [[d == -1 ? '*' : d == 0 ? ' ' : codepoint('0') + Char(d) for d in s] |> String for s in eachcol(flagged)]
end

# This function works for hypercube minefields too, which is pretty cool.
# If you decide to construct your own hypercube minefield, bear in mind that
# the curse of dimensionality means that mines become useless as the number of
# dimensions increases to even moderate numbers.
#
# (A more useful metric for 'danger from mines' is the percentage of neighbouring
# cells which contain mines).
function flag_mines(matrix::Array)
    flagged = zeros(Int,size(matrix))
    @inbounds for inds in Tuple.(CartesianIndices(matrix))
        flagged[inds...] = matrix[inds...] == 1 ? -1 : sum(window(matrix,inds,ones(Int,length(size(matrix)))))
    end
    flagged
end

function window(mat,coords,δs)
    dims = size(mat)
    view(mat, (max(1,c-δ):min(dims[dim],c+δ) for (dim,(δ,c)) in enumerate(zip(δs,coords)))...)
end

# Testing
using BenchmarkTools
mines(n,m) = [rand([repeat(' ',4)...; '*'],m) |> String for _ in 1:n]
@benchmark annotate(m) setup=(m=mines(20,20))
