function encode(s)
    map(r -> "$(length(r) > 1 ? length(r) : "")$(s[r[1]])"
    , findall(r"(.)\1*",s)) |> join
end

function decode(s)
    map(r -> begin
            count_str = s[r[1:end-1]]
            count = isempty(count_str) ? 1 : parse(Int,count_str)
            repeat(s[r[end]],count)
        end,
        findall(r"[0-9]*[^0-9]",s)
    ) |> join
end

# This chap's solution is neat - it's similar to my first attempt (not shown)
# but uses an IOBuffer to get past the slowness of constantly appending to strings
# https://exercism.io/tracks/julia/exercises/run-length-encoding/solutions/e30fdad5ddec41439f749e321e076d1b
function outputrun!(buf, char, length)
    if length == 0
        return # do nothing
    elseif length == 1
        print(buf, char)
    else
        print(buf, length)
        print(buf, char)
    end
end

function encode(s)
    runchar = 'a' # arbitrary
    runlength = 0
    buf = IOBuffer()
    for char in s
        if char == runchar
            runlength += 1
        else
            outputrun!(buf, runchar, runlength)
            runlength = 1
            runchar = char
        end
    end
    outputrun!(buf, runchar, runlength)
    String(take!(buf))
end

# NB: code for old Julia, needs updating
# function decode2(buf, char, length)
#     for i in 1:length
#         print(buf, char)
#     end
# end
# 
# function decode(s)
#     buf = IOBuffer()
#     numbuf = IOBuffer()
#     for char in s
#         if isalpha(char) || isspace(char)
#             size = 1
#             if numbuf.size > 0
#                 size = parse(Int64, String(take!(numbuf)))
#             end
#             decode2(buf, char, size)
#         else
#             @assert isnumber(char)
#             print(numbuf, char)
#         end
#     end
#     String(take!(buf))
# end
