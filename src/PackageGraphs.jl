module PackageGraphs

using Pkg, CSV, DataFrames, Downloads, Dates, UUIDs

const REGISTRY_CACHE = Ref{Pkg.Registry.RegistryInstance}()
function default_registry()
    if !isassigned(REGISTRY_CACHE)
        REGISTRY_CACHE[] = last(last(only(Pkg.Registry.REGISTRY_CACHE)))
        #REGISTRY_CACHE[] = Pkg.Registry.RegistryInstance(joinpath(homedir(), ".julia/registries/General"))
    end
    REGISTRY_CACHE[]
end

include("download_stats.jl")
include("conversions.jl")
include("dependencies.jl")
include("docstrings.jl")

end
