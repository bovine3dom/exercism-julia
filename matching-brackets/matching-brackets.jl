const CLOSING_BRACKET = Dict{Char,Char}(
    '(' => ')',
    '[' => ']',
    '{' => '}',
)
const ISOPENER = Dict(k=>k in keys(CLOSING_BRACKET) for k in [keys(CLOSING_BRACKET)..., values(CLOSING_BRACKET)...]) 

function matching_brackets(s::String)
    desired_close::Array{Char} = []
    for c in s
        isopener = get(ISOPENER,c,nothing)
        if !isnothing(isopener)
            if isopener
                push!(desired_close, CLOSING_BRACKET[c])
            else
                (isempty(desired_close) || c != pop!(desired_close)) && return false
            end
        end
    end
    isempty(desired_close)
end
