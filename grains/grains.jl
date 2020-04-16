"""Calculate the number of grains on square `square`."""
function on_square(square)
    square < 1 && throw(DomainError("Square cannot be negative"))
    square > 64 && throw(DomainError("There are only 64 squares on a chessboard"))
    _on_square(square)
end

# "Follow the question" implementation
function _on_square(square)
    square == 1 && return Int128(1)
    2*on_square(square-1)
end

"""Calculate the total number of grains after square `square`."""
function total_after(square)
    square < 1 && throw(DomainError("Square cannot be negative"))
    sum(on_square.(1:square))
end

# "Let's do some maths" implementation
function _on_square_quick(square)
    Int128(2)^(square-1)
end

# I had two options:
# 1. Try to remember how sums of geometric series work
# 2. use SymPy
# ```
# using SymPy
# @vars(k, n)
# summation(2^(k-1),(k,(1,n)))
# ```
function total_after_quick(square)
    Int128(2)^(square+1)÷2-1
end
