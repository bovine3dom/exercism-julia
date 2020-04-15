function encode(input::S) where S <: AbstractString
    flipalpha.(codeunits(input)) |> skipmissing |> collect |> s->StringPadIterator(5,s) |> collect |> String |> rstrip
    #flipalpha.(codeunits(input)) |> skipmissing |> s->padtruth(5,s)
end

decode(input::T) where T <:AbstractString = flipalpha(input) |> skipmissing |> collect |> T

struct StringPadIterator{T<:Union{AbstractString,AbstractArray}}; n::Int; s::T; end

# Indexing directly into strings like this is not a good idea, e.g. "⊗j[2]"
# Luckily we drop all difficult characters in flipalpha so we needn't worry
#
# Ideally this would accept an iterator in place of s so we didn't need to collect it needlessly
@inline Base.iterate(it::StringPadIterator) = (it.s[1],2)
@inline Base.iterate(it::StringPadIterator,pos) = begin
    if (length(it.s) < pos - pos÷(it.n+1)) 
        nothing
    # todo: if this is the last character, don't return it
    elseif rem(pos,it.n+1) == 0 
        (' ',pos+1) 
    else 
        (it.s[pos - pos÷(it.n+1)], pos+1)
    end
end
Base.length(it::StringPadIterator) = length(it.s) + length(it.s)÷it.n
Base.eltype(::Type{StringPadIterator{T}}) where T = Char

# This is slower than the iterator but it was much easier to write;
# I used it to check the correctness of the function above
function padtruth(n,s)
    a = ""
    for (i,c) in enumerate(s)
        a *= rem(i,n)==0 ? "$(Char(c)) " : Char(c)
    end
    a
end

const LOWERA = codepoint('a')
const LOWERZ = codepoint('z')
const UPPERA = codepoint('A')
const UPPERZ = codepoint('Z')

flipalpha(s::AbstractString) = flipalpha.(codeunits(s))
function flipalpha(c::T)::Union{UInt8,Missing} where T <: Unsigned
    if LOWERA <= c <= LOWERZ
        T(LOWERA+LOWERZ) - c
    elseif UPPERA <= c <= UPPERZ
        T(LOWERA+LOWERZ) - c - T(LOWERA-UPPERA) # convert to lowercase
    elseif codepoint('0') <= c <= codepoint('9')
        c
    else
        missing
    end
end
# For testing:
# using BenchmarkTools
# @benchmark encode(s) setup=(s=rand('a':'z',100_000)|>join)
