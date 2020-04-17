⊙(s::AbstractString,::Nothing) = s
⊙(::Nothing,::Nothing) = nothing
⊙(n::Nothing,s::AbstractString) = s⊙n
⊙(l::AbstractString,r::AbstractString) = l*r

const ROMAN_NUMERALS = merge!(Base.ImmutableDict{Int,String}(),Dict(
    1 => "I",
    2 => "II",
    3 => "III",
    4 => "IV",
    5 => "V",
    6 => "VI",
    7 => "VII",
    8 => "VIII",
    9 => "IX",
    10 => "X",
    20 => "XX",
    30 => "XXX",
    40 => "XL",
    50 => "L",
    60 => "LX",
    70 => "LXX",
    80 => "LXXX",
    90 => "XC",
    100 => "C",
    200 => "CC",
    300 => "CCC",
    400 => "CD",
    500 => "D",
    600 => "DC",
    700 => "DCC",
    800 => "DCCC",
    900 => "CM",
    1000 => "M",
    2000 => "MM",
    3000 => "MMM",
))

# Using immutable dicts is a little bit of a faff, but worth it for a 100x speedup
function roman(digit)
    # The pattern is "add them up until you are 1 step away from the next digit, then do subtraction"
    # I don't fancy coding that up
    digit == 0 && return nothing
    ROMAN_NUMERALS[digit]
end

function to_roman(number::Integer)
    (number <= 0  || number >= 3999) && throw(ErrorException("That number doesn't exist :)"))
    mapreduce(t->roman(t[2]*(10^(t[1]-1))),⊙,Iterators.reverse(enumerate(digits(number,base=10))))
end

# Hat-tip to jlapeyre: https://discourse.julialang.org/t/way-to-construct-multi-key-immutabledict/10294/2#post_5
function Base.merge!(d::Base.ImmutableDict, dsrc::Dict)
    for (k,v) in dsrc
        d = Base.ImmutableDict(d,k=>v)
    end
    d
end
