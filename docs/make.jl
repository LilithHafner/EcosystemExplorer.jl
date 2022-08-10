using EcosystemExplorer
using Documenter

DocMeta.setdocmeta!(EcosystemExplorer, :DocTestSetup, :(using EcosystemExplorer); recursive=true)

makedocs(;
    modules=[EcosystemExplorer],
    authors="Lilith Hafner <Lilith.Hafner@gmail.com> and contributors",
    repo="https://github.com/LilithHafner/EcosystemExplorer.jl/blob/{commit}{path}#{line}",
    sitename="EcosystemExplorer.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://LilithHafner.github.io/EcosystemExplorer.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LilithHafner/EcosystemExplorer.jl",
    devbranch="main",
)
