export dependencies, dependents, dependents_on_old, dependent_uuids, dependent_uuids_on_old, indirect

function load_dependencies()
    isempty(UUID_VERSION_BY_LUID) && @warn "No registries loaded"
    unsats = LUID[]
    resize!(LUID_DEPENDENCY_GRAPH, length(UUID_VERSION_BY_LUID))
    for i in eachindex(LUID_DEPENDENCY_GRAPH)
        id = LUID(i)
        v = version(id)
        deps = Vector{LUID}[]
        entry = ENTRIES_BY_UUID[uuid(id)]
        if entry isa Stdlib
            LUID_DEPENDENCY_GRAPH[i] = Vector{UInt32}[] # TODO this is not right
            # fixing this should come with a comprehensive understanding of how
            # package versions relate to julia versions (or should come with the
            # abolition of stdlibs)
            continue
        end
        for (vr, compats) in entry.info.compat
            if v ∈ vr
                for (n, vr2) in compats
                    n == "julia" && continue
                    dep = UInt32[]
                    for v2 in versions(n)
                        if v2 ∈ vr2
                            push!(dep, luid(n, v2))
                        end
                    end
                    if isempty(dep)
                        version(id) < latest_version(package_name(id)) ||
                            @warn "Unsatisfied dependency for: $(name(id))"
                        # If it's an old version, don't worry about it.
                        # Probably standard library migration or something.
                    else
                        push!(deps, dep)
                    end
                end
            end
        end
        LUID_DEPENDENCY_GRAPH[id] = deps
    end
end

dependency_luids(p::LUID) = LUID_DEPENDENCY_GRAPH[p]
dependency_luids(p) = dependency_luids(latest_luid(p))
dependency_luids(p, v) = dependency_luids(luid(p, v))

dependencies(args...) = map(dependency_luids(args...)) do dep
    package_name(first(dep)) => version.(dep)
end

dependent_uuids(p) = dependent_uuids(latest_luid(p))
dependent_uuids(p, v) = dependent_uuids(luid(p, v))
dependent_uuids(p::LUID) = filter(packages()) do u
    p ∈ vcat(dependency_luids(u)...)
end
dependents(args...) = name.(dependent_uuids(args...))

dependent_uuids_on_old(p) = dependent_uuids_on_old(uuid(p))
function dependent_uuids_on_old(p::UUID)
    all = luids(p)
    latest = last(all)
    filter(packages()) do u
        deps = vcat(dependency_luids(u)...)
        !isdisjoint(deps, all) && latest ∉ deps
    end
end
dependents_on_old(args...) = name.(dependent_uuids_on_old(args...))

function summary(p=packages())
    df = DataFrame(
        name=name.(p),
        version=latest_version.(p),
        downloads=downloads.(p),
        dependencies=[first.(dependencies(x)) for x in p],
        dependents=[String[] for x in p],
        uuid=p,
    )
    for (i, pkg) in enumerate(p)
        for dep in dependencies(pkg)
            push!(df.dependents[i], first(dep))
        end
    end
    sort!(df, [order(:downloads, rev=true), order(:dependents, by=length, rev=true),
               order(:version, rev=true), :name])
end

function indirect(f::Function, root)
    history = Set([root])
    stack = [root]
    while !isempty(stack)
        x = pop!(stack)
        for y in f(x)
            if y ∉ history
                push!(stack, y)
                push!(history, y)
            end
        end
    end
    history
end

indirect(::typeof(dependencies), root) = indirect(x -> first.(dependencies(x)), root)
