export load

function in_temp_environment(f)
    project = dirname(Base.active_project())
    try
        redirect_stderr(devnull) do
            Pkg.activate(temp=true)
        end
        f()
    finally
        redirect_stderr(devnull) do
            Pkg.activate(project)
        end
    end
end

"""
    load([registries...])

TODO: Untested with more than 1 registry.
"""
function load(registries...)
    foreach(load_registry, registries)
    load_dependencies()
end

function load()
    if isempty(Pkg.Registry.REGISTRY_CACHE)
        in_temp_environment() do
            Pkg.update()
        end
    end
    regs = if isempty(Pkg.Registry.REGISTRY_CACHE)
        path = joinpath(homedir(), ".julia/registries/General")
        reg = Pkg.Registry.RegistryInstance(path)
        @warn "Pkg.Registry.REGISTRY_CACHE is empty, using registry at $path instead."
        [reg]
    else
        last.(values(Pkg.Registry.REGISTRY_CACHE))
    end
    @assert !isempty(regs)
    load(regs...)
end
