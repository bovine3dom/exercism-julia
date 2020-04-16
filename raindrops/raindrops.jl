# If number has 3 as a factor, output 'Pling'
# If number has 5 as a factor, output 'Plang'
# 7 as a factor, output 'Plong'

function raindrops(number::Int)
    # Handy for checking we've covered every case:
    # julia> Iterators.product(("3",""),("5",""),("7","")) |> collect
    if number % 3 == 0
        if number % 5 == 0
            if number % 7 == 0
                "PlingPlangPlong"
            else
                "PlingPlang"
            end
        elseif number % 7 == 0
            "PlingPlong"
        else
            "Pling"
        end
    elseif number % 5 == 0
        if number % 7 == 0
            "PlangPlong"
        else
            "Plang"
        end
    elseif number % 7 == 0
        "Plong"
    else
        string(number)
    end
end

# This was much faster to write and much more extensible
# It's about 30x slower if all 3 factors match, 10x slower if two factors match, but the same speed for every other number
using StaticArrays: @SVector

⊙(s::AbstractString,::Nothing) = s
⊙(::Nothing,::Nothing) = nothing
⊙(n::Nothing,s::AbstractString) = s⊙n
⊙(l::AbstractString,r::AbstractString) = l*r

function raindrops_nothing(number::Int)
    fungen(fact,sound) = x -> rem(x,fact) == 0 ? sound : nothing
    funs = @SVector [
        fungen(3,"Pling"),
        fungen(5,"Plang"),
        fungen(7,"Plong"),
    ]
   res = mapreduce(f->f(number),⊙,funs)
   isnothing(res) ? string(number) : res
end
