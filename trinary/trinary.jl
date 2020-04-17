function trinary_to_decimal(str::AbstractString)
    result = 0
    try
        for (i,d) in enumerate(Iterators.reverse(str))
            p = parse(Int,d)
            p > 3 && return 0
            result += p*(3^(i-1))
        end
    catch(e)
        isa(e,ArgumentError) && return 0
        throw(e)
    end
    result
end

# Approx 2x quicker. From @edit it looks like Julia is using :ccall, which I think counts as cheating
function trinary_to_decimal_reference(str::AbstractString)
    try
        parse(Int,str,base=3)
    catch(e)
        return 0
    end
end
