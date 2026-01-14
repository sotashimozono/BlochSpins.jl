module BlochSpins

using StaticArrays, LinearAlgebra

include("core/struct.jl")
include("core/constants.jl")

include("utils/spin_dynamics.jl")
include("utils/visualize.jl")
include("export.jl")

end
