@testset "Constants and Superpositions" begin
    # 直交性のテスト
    @test b_up * k_down ≈ 0.0 atol=1e-15
    @test b_plus * k_minus ≈ 0.0 atol=1e-15
    
    # 期待値のテスト
    @test expect(σx, k_plus)  ≈  1.0
    @test expect(σx, k_minus) ≈ -1.0
    @test expect(σy, k_right) ≈  1.0
    
    # パウリ行列の交換関係 [σx, σy] = 2iσz の確認 (Operator型での計算)
    # ※ Operator同士の積を定義している前提
    @test (σx * σy).data ≈ (1im * σz).data
end