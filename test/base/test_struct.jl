using LinearAlgebra

@testset "BlochSpins.jl Tests" begin
    @testset "Basic Definitions" begin
        k = Ket[1, 0]
        @test k[1] == 1.0
        @test k' isa Bra
        @test (k')' === k
    end

    @testset "Algebra" begin
        up = Ket[1, 0]
        down = Ket[0, 1]
        
        # 内積 <up|down> = 0, <up|up> = 1
        @test up' * down ≈ 0.0 atol=1e-15
        @test up' * up ≈ 1.0
        
        # 外積 |up><up| = [1 0; 0 0]
        P_up = up * up'
        @test P_up.data == [1 0; 0 0]
    end

    @testset "Physics" begin
        up = Ket[1, 0]
        # σz |up> = 1 * |up>
        @test expect(σz, up) ≈ 1.0
        # σx |up> = |down>, <up|σx|up> = 0
        @test expect(σx, up) ≈ 0.0 atol=1e-15
        
        plus = normalize(Ket[1, 1])
        @test expect(σx, plus) ≈ 1.0
    end
end