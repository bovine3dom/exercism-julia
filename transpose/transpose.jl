function transpose_strings(input::AbstractArray)
    # This saves us from having to make a special case for maximum below
    input == [] && return []

    # Construct a matrix from the strings where empty spaces are replaced with missing
    zenith = maximum(length,input)
    result = Array{Union{Missing,Char},2}(undef,length(input),zenith)
    for (i,s) in enumerate(input)
        for j in 1:zenith
            @inbounds result[i,j] = get(s,j,missing)
        end
    end

    # For every column, remove trailing missings, replace the rest with spaces and convert into a string
    [string_lpadmissing!(r) for r in eachcol(result)]
end

# This modifies its input and returns something else which may be surprsing
# but as we're using eachcol we get a copy anyway
function string_lpadmissing!(maybechars)
    # replace the missings up to the last character with spaces
    last = findlast(!ismissing,maybechars)
    last = isnothing(last) ? 0 : last
    for i in 1:last-1 # we know last isn't missing
        if ismissing(maybechars[i]); maybechars[i] = ' '; end
    end

    # leave out the missings after the last character
    String(Array{Char,1}(maybechars[1:last]))
end

# For testing:
strs = [rand("qwertyuiop",rand(900:1000,1)|>first)|>join for _ in 1:1_000];

# The tests could be harder: they don't test for preserving trailing spaces in the input, e.g.
# ```
# julia> transpose_strings(["abcedf","abc","def "])
# 6-element Array{String,1}:
#  "aad"
#  "bbe"
#  "ccf"
#  "e  "
#  "d"
#  "f"
# ```
#
# From the task description:
# In general, all characters from the input should also be present in the transposed output. That means that if a column in the input text contains only spaces on its bottom-most row(s), the corresponding output row should contain the spaces in its right-most column(s).
#
# (without this constraint a ~two liner with hcat, lpad, and rstrip suffices)
