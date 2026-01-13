using BlochSpins
using Documenter

makedocs(
    sitename = "BlochSpins.jl",
    modules  = [BlochSpins],
    pages    = [
        "Home" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/sotashimozono/BlochSpins.jl.git",
)