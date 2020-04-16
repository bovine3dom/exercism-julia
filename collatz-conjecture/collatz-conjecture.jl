function collatz_steps(n::Integer)
    n < 1 && throw(DomainError("n must be positive"))
    count = 0
    while n > 1
        count += 1
        n = isodd(n) ? 3n + 1 : n ÷ 2
    end
    count
end

# Recursion: hard to reason about and slow in Julia as there's no TCO.
function collatz_steps_slow(n::Integer)
    # Avoid checking n < 1 in every loop
    n < 1 && throw(DomainError("n must be positive"))
    _collatz_steps(n)
end

function _collatz_steps(n::Integer)
    n == 1 && return 0
    isodd(n) && return 2 + _collatz_steps((3n + 1) ÷ 2)
    1 + _collatz_steps(n÷2)
end

