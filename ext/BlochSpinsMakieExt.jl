module BlochSpinsMakieExt

using BlochSpins
using Makie

import BlochSpins: init_figure, visualize_bloch_sphere!, visualize_axis!, visualize_vector!
# TODO : constuct visualization utils

"""
    init_figure()
Initialize a 3D figure for Bloch sphere visualization.
it returns a tuple (fig, ax) where `fig` is the Figure and `ax` is the LScene axis.
"""
function init_figure()
    fig = Figure(size = (800, 800))
    ax = LScene(fig[1, 1], show_axis = false)
    return fig, ax
end

"""
    visualize_bloch_sphere!(fig, ax)
Draws a Bloch sphere in the given axis `ax` of the figure `fig`.
"""
function visualize_bloch_sphere!(fig, ax)
    # draw sphere
    mesh!(ax, Sphere(Point3f(0), 1f0), color = (:skyblue, 0.15), transparency = true)
    # draw wireframe
    wireframe!(ax, Sphere(Point3f(0), 1f0), color = (:black, 0.1), linewidth = 0.5)
end
"""
    visualize_axis!(fig, ax)
Draws the X, Y, Z axes in the given axis `ax` of the figure `fig`.
"""
function visualize_axis!(fig, ax)
    # (X, Y, Z) axes
    lines!(ax, [-1, 1], [0, 0], [0, 0], color = :red)
    lines!(ax, [0, 0], [-1, 1], [0, 0], color = :green)
    lines!(ax, [0, 0], [0, 0], [-1, 1], color = :blue)
    # axis labels
    text!(ax, "X", position = Point3f(1.1, 0, 0), color = :red)
    text!(ax, "Y", position = Point3f(0, 1.1, 0), color = :green)
    text!(ax, "Z", position = Point3f(0, 0, 1.1), color = :blue)
end
"""
    visualize_vector!(fig, ax, vec)
Draws a vector `vec` originating from the origin in the given axis `ax` of the figure `fig`.
"""
function visualize_vector!(fig, ax, vec)
    b_vec = real.(vec)
    arrows3d!(ax, [Point3f(0)], [Point3f(b_vec...)], 
        tipradius = 0.05, 
        tiplength = 0.1, 
        shaftradius = 0.01, 
        
        diffuse = 0.8, 
        color = :black,
        transparency = true
    )
end

end