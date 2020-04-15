"Square the sum of the numbers up to the given number" # These descriptions were the wrong way round in the skeleton
# I knew GCSE maths would come in handy one day
# a = 1 + 2 + ... + n
# b = n + ... + 2 + 1
# a+b = n(n+1)
# => sum = n(n+1) ÷ 2 # even * odd = even
function square_of_sum(n::Integer)
#   These two lines are just as fast as each other: it turns out that Julia knows GCSE maths too
#   (see sum(::Abstractrange{<:Real}) in base/range.jl)
#   (n*(n+1) ÷ 2) ^ 2
    sum(Base.OneTo(n))^2
end

# a = 1^2 + 2^2 + ... + n
# b = n^2 + (n-1)^2 + ...
#
# Telescoping series trick:
# sum(k^2 - (k-1)^2) = n^2
# k^2 - (k^2 - 2k +1) = 2k - 1
# => sum(k^2 - (k-1)^2) = sum(2k - 1) = 2*sum(k) - n = n^2 => sum(k) = (n^2 + n) / 2
#
# We want sum([telescoping thing]) ∝ (sum(k^2) + tractable stuff)
# => try sum(k^3 - (k-1)^3) = n^3
# = sum(k^3 - (k-1)(k^2 - 2k +1)) = sum(k^3 - (k^3 -3k^2 +3k -1)) = sum(3k^2 - 3k +1) = 3*sum(k^2) - 3*sum(k) + n = n^3
# => sum(k^2) = 1/3 * (n^3 - n + 3(n(n+1))/2) = 1/3 n^3 + 1/2 n^2 + 1/6 n = n/6 * (2n^2 + 3n + 1) = n/6 * (2n + 1)(n + 1)
#
# Slightly faster way of getting this:
# ```
# using SymPy
# @vars(k,n)
# summation(k^2,(k,(1,n)))
# ```
#
# Can turn it into a function with summation(...).evalf() but it uses Python so it's slow - better off copying it out manually
"Sum the squares of the numbers up to the given number" # These descriptions were the wrong way round in the skeleton
function sum_of_squares(n::Integer)
    n*(2n+1)*(n+1) ÷ 6
end

"Subtract sum of squares from square of sums"
function difference(n::Integer)
    square_of_sum(n) - sum_of_squares(n) 
end
