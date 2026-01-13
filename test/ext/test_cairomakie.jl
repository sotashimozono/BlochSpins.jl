using CairoMakie

@testset "BlochSpinsMakieExt Tests" begin
    @testset "Initialization" begin
        fig, ax = init_figure()
        @test fig isa Figure
        @test ax isa LScene
    end

    @testset "Sphere Visualization" begin
        fig, ax = init_figure()
        @test_nowarn visualize_bloch_sphere!(fig, ax)
        @test length(ax.scene.plots) >= 2 
    end

    @testset "Axis Visualization" begin
        fig, ax = init_figure()
        @test_nowarn visualize_axis!(fig, ax)
        @test length(ax.scene.plots) >= 6
    end

    @testset "Vector Visualization" begin
        fig, ax = init_figure()
        
        v = bloch_vector(k_plus)
        @test_nowarn visualize_vector!(fig, ax, v)
        @test any(p -> p isa Makie.Arrows, ax.scene.plots)
    end
end