# Inspired by https://discourse.julialang.org/t/slow-custom-digits-iterator/31367
# Expanded to accept more kinds of integer
struct DigitsIterator{T<:Integer}; n::T; end
@inline Base.iterate(it::DigitsIterator) = it.n == 0 ? (0,0) : iterate(it,it.n)
@inline Base.iterate(it::DigitsIterator,el) = el == 0 ? nothing : reverse(divrem(el,10))
Base.length(it::DigitsIterator) = ndigits(it.n)
Base.eltype(::Type{DigitsIterator{T}}) where T = T

function isarmstrong(n::Integer)
    ds = DigitsIterator(n) # digits(n) also works but allocates and is slower
    n == sum(x->x^length(ds),ds)
end
