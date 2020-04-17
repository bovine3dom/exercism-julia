import Dates
struct Clock
    hours::Int8
    minutes::Int8
    Clock(h,m) = new(rem(h + div(m,60,RoundDown),24,RoundDown),rem(m,60,RoundDown))
end

Base.:+(c::Clock,m::Dates.Minute) = Clock(c.hours, c.minutes + m.value)
Base.:-(c::Clock,m::Dates.Minute) = Clock(c.hours, c.minutes - m.value)
Base.:+(c::Clock,h::Dates.Hour) = Clock(c.hours + h.value, c.minutes)
Base.:-(c::Clock,h::Dates.Hour) = Clock(c.hours - h.value, c.minutes)

Base.show(io::IO, c::Clock) = print(io, '"', lpad(c.hours,2,'0'), ":", lpad(c.minutes,2,'0'), '"')
