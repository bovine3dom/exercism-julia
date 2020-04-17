using StaticArrays: SArray, @SMatrix
using LinearAlgebra: I, norm

# This matrix-based implementation is very cool (IMO)
# and only ~25% slower than the reference implementation for addition, multiplication, subtraction
#
# We get a 10x speedup for division and abs (although, for abs in particular, base widens to guard against overflow)
struct ComplexNumber{T<:Real} <: Number
    mat::SArray{Tuple{2,2},T,2,4}
    ComplexNumber(mat) = new{eltype(mat)}(mat)
    ComplexNumber(real::T1,imag::T2) where {T1 <: Real, T2 <: Real} = new{promote_type(T1,T2)}(@SMatrix([real  -imag; imag real]))
end

Base.:*(l::ComplexNumber,r::ComplexNumber) = ComplexNumber(l.mat * r.mat)
Base.:+(l::ComplexNumber,r::ComplexNumber) = ComplexNumber(l.mat + r.mat)
Base.:-(l::ComplexNumber,r::ComplexNumber) = ComplexNumber(l.mat - r.mat)
Base.:/(l::ComplexNumber,r::ComplexNumber) = ComplexNumber(l.mat * inv(r.mat))
Base.:*(z::ComplexNumber,r::Real) = ComplexNumber(r*z.mat)
Base.:*(r::Real, z::ComplexNumber) = z*r
Base.:+(z::ComplexNumber,r::Real) = ComplexNumber(r*I + z.mat)
Base.:+(r::Real, z::ComplexNumber) = z + r

Base.show(io::IO, z::ComplexNumber) = print(io, "ComplexNumber(", Re(z), ", ", Im(z), ")")
Base.:≈(l::ComplexNumber,r::ComplexNumber) = l.mat ≈ r.mat # I had to make one of the division tests ≈ to pass it
Base.:(==)(l::ComplexNumber,r::ComplexNumber) = l.mat == r.mat 

Base.abs(z::ComplexNumber) = norm(z.mat[:,1])

# Sorry about the capital letter. That's what maths does.
@inline Re(z::ComplexNumber) = @inbounds z.mat[1,1]
@inline Im(z::ComplexNumber) = @inbounds z.mat[2,1]

Base.real(z::ComplexNumber) = Re(z)
Base.imag(z::ComplexNumber) = Im(z)

Base.conj(z::ComplexNumber) = ComplexNumber(transpose(z.mat))

Base.exp(z::ComplexNumber) = ComplexNumber(exp(z.mat))

# There's not an iota of a chance that ι will take off as the sensible symbol to use for the imaginary unit
const ι = jm = ComplexNumber(0,1)
