using PackageGraphs
using Documenter

DocMeta.setdocmeta!(PackageGraphs, :DocTestSetup, :(using PackageGraphs); recursive=true)

makedocs(;
    modules=[PackageGraphs],
    authors="Lilith Hafner <Lilith.Hafner@gmail.com> and contributors",
    repo="https://github.com/LilithHafner/PackageGraphs.jl/blob/{commit}{path}#{line}",
    sitename="PackageGraphs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://LilithHafner.github.io/PackageGraphs.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LilithHafner/PackageGraphs.jl",
    devbranch="main",
)
