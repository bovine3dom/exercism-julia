function pythagorean_triplets(N::Int)::Array{Tuple{Int,Int,Int},1}
    # Return all (a,b,c) such that:
    # a + b + c = N
    # a^2 + b^2 = c^2
    # a < b < c

    # Pythagorean triplets: Euclid did this a while ago
    # a = m^2 - n^2, b = 2mn, c = m^2 + n^2
    # so a + b + c = 2m^2 + 2mn = N
    # m(m + n) = N/2: not nice for generation, so let's give up and filter by it instead
    #
    # Need to take care of int multiples so also k.*(a,b,c) => km(m+n) = N/2 too
    # => N/2 / m(m+n) is an integer: divrem(N/2,m(m+n))
    
    # TODO / exercise for the reader: ensure bounds on N/2 are as tight as they can be
    sort!(triple.(Iterators.filter(x->conditions(x[1],x[2],N),Iterators.product(1:N/2,1:N/2)),N) |> unique; by=x->x[1])
end

function conditions(m,n,N)
    m > n > 0 &&
    rem(N/2,m*(m+n)) == 0
end

triple(t,N) = triple(t[1],t[2],N)

# We only make the triple of answers that we know will work so there's no point optimising this
triple(m,n,N) = div(N/2,m*(m+n)).*sort!((m^2 - n^2, 2m*n, m^2 + n^2) |> collect) |> Tuple{Int,Int,Int}

# This is vastly faster than mine, it's not fair
# https://exercism.io/tracks/julia/exercises/pythagorean-triplet/solutions/369f511a364d4ce0b9c054c55b49d8d8
function pythagorean_triplets(x::Int)

	triplets = Array{Tuple{Int64,Int64,Int64}}(undef, 0)
	for a in 1:(x ÷ 3)
		for b in (a+1):(x ÷ 2 + 1)

			c = x - a - b
			if (a*a + b*b == c*c)
				push!(triplets, (a, b, c))
			end
		end
	end
	return triplets
end
