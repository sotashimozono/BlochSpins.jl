using BlochSpins
using Documenter
using Literate
using CairoMakie
CairoMakie.activate!()

# define paths
SCRIPT_DIR = joinpath(@__DIR__, "..", "script")
OUTPUT_DIR = joinpath(@__DIR__, "src", "generated")
mkpath(OUTPUT_DIR)

filenames = [
    "visualize_residuals",
]
for filename in filenames
    Literate.markdown(
        joinpath(SCRIPT_DIR, filename * ".jl"),
        OUTPUT_DIR;
        execute=true,
    )
end
makedocs(;
    modules=[BlochSpins],
    sitename="BlochSpins.jl",
    pages=[
        "Home" => "index.md",
        "Examples" => [
            "Visualize Residual Vector" => "generated/visualize_residuals.md",
        ],
    ],
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://codes.sota-shimozono.com/BlochSpins.jl",
        size_threshold=1000 * 1024,
        size_threshold_warn=800 * 1024,
    ),
)

deploydocs(; repo="github.com/sotashimozono/BlochSpins.jl.git")
