abstract type AbstractQuantumObject{T} end
abstract type AbstractState{T} <: AbstractQuantumObject{T} end
abstract type AbstractOperator{T} <: AbstractQuantumObject{T} end

struct Ket{T} <: AbstractState{T}
    v::SVector{2, T}
end

struct Bra{T} <: AbstractState{T}
    v::Adjoint{T, SVector{2, T}}
end

Base.getindex(s::AbstractState, i::Int) = s.v[i]
Base.length(s::AbstractState) = length(s.v)

Base.getindex(::Type{Ket}, x, y) = Ket(SVector{2, ComplexF64}(x, y))

# adjoint
Base.adjoint(k::Ket) = Bra(adjoint(k.v))
Base.adjoint(b::Bra) = Ket(adjoint(b.v))

# operations
Base.:*(b::Bra, k::Ket) = b.v * k.v
Base.:+(k1::Ket, k2::Ket) = Ket(k1.v + k2.v)
Base.:-(k1::Ket, k2::Ket) = Ket(k1.v - k2.v)
Base.:*(c::Number, k::Ket) = Ket(c * k.v)


struct Operator{T} <: AbstractOperator{T}
    data::SMatrix{2, 2, T, 4}
end

Base.getindex(A::Operator, i::Int, j::Int) = A.data[i, j]
Base.getindex(::Type{Operator}, a, b, c, d) = Operator(@SMatrix [a b; c d])
function Base.typed_hvcat(::Type{Operator}, dims::Tuple{Int,Int}, elements...)
    return Operator(SMatrix{2, 2, ComplexF64, 4}(elements...))
end

# adjoint
Base.adjoint(A::Operator) = Operator(adjoint(A.data))

# operations
Base.:*(A::Operator, k::Ket) = Ket(A.data * k.v)
Base.:*(b::Bra, A::Operator) = Bra(b.v * A.data)
Base.:*(A::Operator, B::Operator) = Operator(A.data * B.data)
Base.:*(c::Number, A::Operator) = Operator(c * A.data)
Base.:*(A::Operator, c::Number) = Operator(A.data * c)
Base.:+(A::Operator, B::Operator) = Operator(A.data + B.data)
Base.:-(A::Operator, B::Operator) = Operator(A.data - B.data)

# outer product |k><b|
Base.:*(k::Ket, b::Bra) = Operator(k.v * b.v)

function expect(op::AbstractOperator, k::Ket)
    return (k' * op * k)
end
StaticArrays.normalize(k::Ket) = Ket(StaticArrays.normalize(k.v))
StaticArrays.normalize(k::Bra) = Bra(StaticArrays.normalize(k.v))
