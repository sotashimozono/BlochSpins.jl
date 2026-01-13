using Test

@testset "BlochSpins.jl Comprehensive Tests" begin
    @testset "Types and Construction" begin
        @test Ket[1, 0] isa AbstractState
        @test Ket[1, 0] isa Ket{ComplexF64}
        @test σx isa AbstractOperator
        k_complex = Ket[1 + 1im, 0]
        @test k_complex[1] == 1.0 + 1.0im
        op = Operator[1 2; 3 4]
        @test op[1, 1] == 1.0
        @test op[2, 1] == 3.0
    end

    @testset "Linear Algebra (States)" begin
        u = k_up
        d = k_down
        @test (u + d).v ≈ SVector(1.0, 1.0)
        @test (u - d).v ≈ SVector(1.0, -1.0)
        @test (2.0 * u).v == SVector(2.0, 0.0)
        k_raw = Ket[1, 1]
        k_norm = normalize(k_raw)
        @test norm(k_norm.v) ≈ 1.0
        @test k_norm.v[1] ≈ 1/√2
    end

    @testset "Operator Algebra" begin
        @test (σx * σx).data ≈ σ0.data
        @test (σy * σy).data ≈ σ0.data
        @test (σz * σz).data ≈ σ0.data
        @test (σx * σy - σy * σx).data ≈ (2im * σz).data
        @test (σx * σy + σy * σx).data ≈ zeros(SMatrix{2,2}) atol=1e-15
        @test σx'.data == σx.data
        @test σy'.data == σy.data
    end

    @testset "State-Operator Interaction" begin
        @test (σz * k_up).v ≈ k_up.v
        @test (σz * k_down).v ≈ (-1.0 * k_down).v
        σ_plus = 0.5 * (σx + 1im * σy)
        @test (σ_plus * k_down).v ≈ k_up.v
        @test (σ_plus * k_up).v ≈ zeros(SVector{2}) atol=1e-15
    end

    @testset "Physics and Expectation Values" begin
        @test expect(σx, k_plus) ≈ 1.0
        @test expect(σx, k_minus) ≈ -1.0
        @test expect(σy, k_right) ≈ 1.0
        @test expect(σy, k_left) ≈ -1.0
        @test expect(σz, k_plus) ≈ 0.0 atol=1e-15
        @test (b_up * σx).v ≈ b_down.v
    end

    @testset "Adjoint Properties" begin
        ψ = normalize(Ket[1.0im, 2.0])
        val = expect(σy, ψ)
        @test imag(val) ≈ 0.0 atol=1e-15

        @test (σx * ψ)'.v ≈ (ψ' * σx).v
    end
end
