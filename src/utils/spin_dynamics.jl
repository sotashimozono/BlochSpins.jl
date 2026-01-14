function bloch_vector(k::Ket)
    x = expect(σx, k)
    y = expect(σy, k)
    z = expect(σz, k)
    return SVector(x, y, z)
end
export bloch_vector

U(t::Float64, H::Operator) = exp(-im * H.data * t)
export U