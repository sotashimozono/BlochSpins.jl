using BlochSpins
using Documenter

# docs/make.jl の中
Literate.markdown(
    "script/visualize_residuals.jl",
    "docs/src/generated";
    execute=true,
)

makedocs(;
    modules=[BlochSpins],
    sitename="BlochSpins Study Notes",
    pages=[
        "Home" => "index.md", "Visualizing Residuals" => "generated/visualize_residuals.md"
    ],
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true", # GitHub上ではURLを綺麗にする
        canonical="https://あなたのユーザー名.github.io/BlochSpins.jl",
    ),
)

makedocs(; sitename="BlochSpins.jl", modules=[BlochSpins], pages=["Home" => "index.md"])

deploydocs(; repo="github.com/sotashimozono/BlochSpins.jl.git")
