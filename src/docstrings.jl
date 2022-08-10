export docstrings

function get_package(package::Symbol)
    try
        return eval(package)
    catch x
        x isa UndefVarError || rethrow()
    end

    try
        return @eval begin
            import $package
            $package
        end
    catch x
        x isa ArgumentError || rethrow()
    end

    project = dirname(Base.active_project())
    try
        redirect_stderr(devnull) do
            Pkg.activate(temp=true)
            Pkg.add(string(package))
        end
        return @eval Main begin
            import $package
            return $package
        end
    finally
        redirect_stderr(devnull) do
            Pkg.activate(project)
        end
    end
end

"""
    docstrings(package)

Partitions the exported names of `pacakge` into those that do and do not have docstrings.

Returns something of the form `([:those :that :do], [:those, :that, Symbol("don't")])`
"""
function docstrings(package::Symbol)
    pkg = get_package(package)
    with, without = Symbol[], Symbol[]
    for sym in names(pkg)
        ds = string(@eval @doc $pkg.$sym)
        @assert match(r"^No documentation found.\n\nBinding `.*` does not exist.\n$", ds) === nothing
        missin = startswith(ds, "No documentation found.") || startswith(ds, "No docstring found")
        push!(missin ? without : with, sym)
    end
    return with, without
end
docstrings(p::String) = docstrings(Symbol(p))
docstrings(p) = docstrings(name(p))
