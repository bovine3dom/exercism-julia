const LOWERA = codepoint('a')
const LOWERZ = codepoint('z')
const UPPERA = codepoint('A')
const UPPERZ = codepoint('Z')

function rotate(n::Int, s::String)
    String(wraprot.(n,codeunits(s)))
end

# Prettier, but 25% slower for big strings:
# rotate(n::Int, s::String) = map(c->rotate(n,c),s)

rotate(n,c::Char) = Char(wraprot(n,codepoint(c)))

function wraprot(n::Int,c::T)::UInt8 where T <: Unsigned
    if LOWERA <= c <= LOWERZ
        rem(c - T(LOWERA) + T(n), T(26)) + T(LOWERA)
    elseif UPPERA <= c <= UPPERZ
        rem(c - T(UPPERA) + T(n), T(26)) + T(UPPERA)
    else
        c
    end
end

# Shamelessly cribbed from base/reducedim.jl
for n in 1:26
    name = Symbol("R$(n)_str")
    @eval begin
         macro $name(s)
            rotate($n,s)
        end
    end
end

# For testing:
# using BenchmarkTools
# @benchmark rotate(23,s) setup=(s=rand('a':'z',100_000)|>join)
