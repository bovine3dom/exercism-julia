"Returns the last b digits of a number in little-endian binary form"
function lastbbits(n::Integer,b=5)
    map(d->Bool(rem(n>>(d-1),2)), 1:b)
end

using StaticArrays: @SVector
function secret_handshake(code::Integer)
    actions = @SVector ["wink", "double blink", "close your eyes", "jump"]
    # special "reverse" action isn't in actions, so we account for it here
    n_actions = length(actions) + 1
    instructions = lastbbits(code,n_actions)
    decoded = actions[instructions[1:length(actions)]]
    instructions[5] ? decoded |> reverse : decoded
end

# 1.3x speedup on average
function secret_handshake_quick(code::Integer)
    instructions = lastbbits(code)
    decoded = Array{String,1}()

    # reverse is quite an expensive operation, so we want to avoid it
    if instructions[5]
        instructions[4] && push!(decoded,"jump")
        instructions[3] && push!(decoded,"close your eyes")
        instructions[2] && push!(decoded,"double blink")
        instructions[1] && push!(decoded,"wink")
    else
        instructions[1] && push!(decoded,"wink")
        instructions[2] && push!(decoded,"double blink")
        instructions[3] && push!(decoded,"close your eyes")
        instructions[4] && push!(decoded,"jump")
    end
    decoded
end
