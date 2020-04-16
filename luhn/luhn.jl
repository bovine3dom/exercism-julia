function luhn(s::AbstractString)
    length(s) < 2 && return false
    tonumber(c::Char) = Int(c - codepoint('0')) 
    s = replace(s, ' ' => "")
    !all(isdigit,s) && return false
    checksum = sum(
        tuple -> begin
            (i,c) = tuple
            rem(i,2) == 0 ? rem(tonumber(c)*2,9) : tonumber(c)
        end,
        s|>reverse|>enumerate
    )
    rem(checksum,10) == 0
end

# Slower but cooler
function luhn2(s::AbstractString)
    length(s) < 2 && return false
    s = replace(s, ' ' => "")
    !all(isdigit,s) && return false
    digits = parse.(Int,s|>collect)
    digits[end-1:-2:1] = rem.(digits[end-1:-2:1].*2,9)
    rem(sum(digits),10) == 0
end
