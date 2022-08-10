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

    in_temp_environment() do
        redirect_stderr(devnull) do
            Pkg.add(string(package))
        end
        @eval Main begin
            import $package
            $package
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
        undefined = match(r"^No documentation found.\n\nBinding `.*` does not exist.\n$", ds) !== nothing
        undefined && @warn "$package exports $sym but it is not defined"
        missin = undefined ||  startswith(ds, "No documentation found.") || startswith(ds, "No docstring found")
        push!(missin ? without : with, sym)
    end
    return with, without
end
docstrings(p::String) = docstrings(Symbol(p))
docstrings(p) = docstrings(name(p))
