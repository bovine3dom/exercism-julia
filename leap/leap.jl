function is_leap_year(year::Int)
    rem(year,4)    == 0 &&
    (rem(year,100) != 0 ||
     rem(year,400) == 0)
end
