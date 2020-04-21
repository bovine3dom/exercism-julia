modifier(ability) = div(ability - 10, 2, RoundDown)

ability() = sum(sort!([roll() for _ in 1:4])[2:end])

mutable struct DNDCharacter
    strength::Int
    dexterity::Int
    intelligence::Int
    wisdom::Int
    charisma::Int
    constitution::Int
    hitpoints::Int
    function DNDCharacter()
        rolls = [ability() for _ in 1:6]
        new(rolls...,10 + modifier(rolls[end]))
    end
end

roll(n, d) = sum(rand(Base.OneTo(d),n))
roll(d) = roll(1,d)
roll() = roll(6)

function str2roll(str)
    try
        (n, d) = parse.(Int,split(str,'d';limit=2))
        roll(n,d)
    catch(e)
        isa(e,ArgumentError) && throw(ArgumentError("invalid dice roll format"))
        throw(e)
    end
end

""" `roll"4d20"` style rolling, just for fun"""
macro roll_str(str) :(str2roll($str)) end
