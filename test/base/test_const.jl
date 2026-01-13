using BlochSpins
using Test
using LinearAlgebra
using StaticArrays

@testset "BlochSpins.jl - Constants & States" begin

    @testset "Pauli Operator Properties" begin
        # 1. hermitian
        @test σx.data == σx'.data
        @test σy.data == σy'.data
        @test σz.data == σz'.data
        @test σ0.data == σ0'.data

        # 2. unitality
        @test (σx' * σx).data ≈ σ0.data
        @test (σy' * σy).data ≈ σ0.data
        @test (σz' * σz).data ≈ σ0.data

        # 3. pauli matrices
        @test (σx * σy).data ≈ (1im * σz).data
        @test (σy * σz).data ≈ (1im * σx).data
        @test (σz * σx).data ≈ (1im * σy).data
        
        # anti commutation
        @test (σx * σy + σy * σx).data ≈ zeros(SMatrix{2,2}) atol=1e-15
        
        # 4. σ vector
        @test σ[1] === σx
        @test σ[2] === σy
        @test σ[3] === σz
    end

    @testset "Basis State Properties" begin
        # 1. normalization (⟨ψ|ψ⟩ = 1)
        for (name, k) in [(:up, k_up), (:down, k_down), (:plus, k_plus), 
                          (:minus, k_minus), (:right, k_right), (:left, k_left)]
            @test (k' * k) ≈ 1.0 + 0.0im  # inner product
            @test norm(k.v) ≈ 1.0         # vector norm
        end

        # 2. orthogonality
        @test b_up * k_down   ≈ 0.0 atol=1e-15
        @test b_plus * k_minus ≈ 0.0 atol=1e-15
        @test k_right' * k_left ≈ 0.0 atol=1e-15

        # 3. consistency of adjoint relations among constants
        @test b_up.v == k_up'.v
        @test b_plus.v == k_plus'.v
    end

    @testset "Eigenstate Verification (Physics)" begin
        # Verify that each basis state is an eigenstate of the corresponding Pauli matrix
        # σz |up> = +1 |up>, σz |down> = -1 |down>
        @test (σz * k_up).v    ≈ k_up.v
        @test (σz * k_down).v  ≈ -1.0 * k_down.v

        # σx |+> = +1 |+>, σx |-> = -1 |->
        @test (σx * k_plus).v  ≈ k_plus.v
        @test (σx * k_minus).v ≈ -1.0 * k_minus.v

        # σy |R> = +1 |R>, σy |L> = -1 |L>
        @test (σy * k_right).v ≈ k_right.v
        @test (σy * k_left).v  ≈ -1.0 * k_left.v
    end

    @testset "Expectation Values" begin
        # Verify expectation values on the Bloch sphere
        # |+> points in the positive x direction
        @test real(expect(σx, k_plus))  ≈  1.0
        @test abs(expect(σy, k_plus))   < 1e-15
        @test abs(expect(σz, k_plus))   < 1e-15

        # |R> points in the positive y direction
        @test abs(expect(σx, k_right))  < 1e-15
        @test real(expect(σy, k_right)) ≈  1.0
        @test abs(expect(σz, k_right))  < 1e-15
    end

end