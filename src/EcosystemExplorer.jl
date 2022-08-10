module EcosystemExplorer

using Pkg, CSV, DataFrames, Downloads, Dates, UUIDs

__init__() = load()

include("setup.jl")
include("download_stats.jl")
include("conversions.jl")
include("dependencies.jl")
include("docstrings.jl")

end
