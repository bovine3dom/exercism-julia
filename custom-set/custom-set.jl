mutable struct CustomSet{T} <: AbstractSet{T}
    dict::Dict{T,Nothing}
    CustomSet(a) = new{eltype(a)}(Dict(k => nothing for k in a))
    CustomSet(d::Dict) = new{keytype(d)}(d)
end

Base.length(s::CustomSet) = length(s.dict)

Base.iterate(s::CustomSet) = iterate(keys(s.dict))
Base.iterate(s::CustomSet,el) = iterate(keys(s.dict),el)

Base.in(el,s::CustomSet) = haskey(s.dict,el)

Base.keys(s::CustomSet) = keys(s.dict)

Base.union(l::CustomSet, r::CustomSet) = CustomSet(merge(l.dict,r.dict))
Base.union!(l::CustomSet, r::CustomSet) = begin
    merge!(l.dict,r.dict)
    l
end
Base.intersect(l::CustomSet, r::CustomSet) = CustomSet(intersect(keys(l),keys(r)))
Base.intersect!(l::CustomSet, r::CustomSet) = begin
    l.dict = Dict(k => nothing for k in intersect(keys(l),keys(r)))
    l
end

disjoint(l, r) = l ∩ r |> isempty

Base.push!(s::CustomSet, k) = begin
    s.dict[k] = nothing
    s
end

Base.setdiff(l::CustomSet, r::CustomSet) = CustomSet(setdiff(keys(l),keys(r)))
Base.setdiff!(l::CustomSet, r::CustomSet) = begin
    l.dict = Dict(k => nothing for k in setdiff(keys(l),keys(r)))
    l
end

Base.copy(s::CustomSet) = CustomSet(copy(s.dict))

complement = setdiff
complement! = setdiff!
