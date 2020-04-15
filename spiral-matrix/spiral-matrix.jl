@enum DIRECTION RIGHT LEFT DOWN UP
function spiral_matrix(n::Int,m=n)
    spiral = zeros(Int,n,m)
    i = j = counter = 1
    direction = RIGHT
    for counter in 1:n*m
        spiral[i,j] = counter
        t = next_coord(direction,i,j)
        # If the next value is one we haven't set yet, continue on to set it
        if get(spiral,t,1) == 0
            (i,j) = t
        # Otherwise, we have gone out-of-bounds or hit a value we've set in
        # which case we should change direction
        else
            direction = next_dir(direction)
            (i,j) = next_coord(direction,i,j)
        end
    end
    spiral
end

function next_dir(c::DIRECTION)
    c == RIGHT ? DOWN :
    c == DOWN ? LEFT :
    c == LEFT ? UP :
    RIGHT # i.e. c==u
end

function next_coord(c::DIRECTION,i,j)
    c == RIGHT ? (i,j+1) :
    c == LEFT ? (i,j-1) :
    c == DOWN ? (i+1,j) :
    (i-1,j) # c==UP
end
