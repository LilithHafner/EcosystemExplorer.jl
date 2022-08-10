export uuid, name, version, package_name, versions, latest_version, packages, package_names

#= Representations

Package
name::String
uuid::UUID

Package with version
name::String
name::String, version::VersionNumber
uuid::UUID, version::VersionNumber
luid::LUID

!luids are internal!
=#

struct Stdlib
    name::String
    version::VersionNumber
end

const LUID = UInt32

const UUIDS_BY_NAME = Dict{String, UUID}()
const ENTRIES_BY_UUID = Dict{UUID, Union{Stdlib, Pkg.Registry.PkgEntry}}()

const UUID_VERSION_BY_LUID = Tuple{UUID, VersionNumber}[]
const LUID_BY_UUID_VERSION = Dict{Tuple{UUID, VersionNumber}, LUID}()

const LUID_BY_UUID = Dict{UUID, UnitRange{LUID}}()

const LUID_DEPENDENCY_GRAPH = Vector{Vector{UInt32}}[]

uuid(p::UUID) = p
uuid(p) = UUIDS_BY_NAME[name(p)]
name(p::UUID) = ENTRIES_BY_UUID[p].name
function name(p::String)
    uuid = if length(p) == 36
        try
            UUID(p)
        catch x
            x isa ArgumentError || rethrow()
        end
    end
    uuid isa UUID ? name(uuid) : p
end
name(p::Module) = string(p)

uuid(p::LUID) = UUID_VERSION_BY_LUID[p][1]
package_name(p::LUID) = name(uuid(p))
version(p::LUID) = UUID_VERSION_BY_LUID[p][2]
name(p::LUID) = package_name(p) * " v" * string(version(p))
luid(p, v::VersionNumber) = LUID_BY_UUID_VERSION[(uuid(p), v)]

luids(p) = LUID_BY_UUID[uuid(p)]
versions(p) = version.(luids(p))

packages() = collect(keys(ENTRIES_BY_UUID))
package_names() = collect(keys(UUIDS_BY_NAME))
latest_luid(p) = last(luids(p))
latest_version(p) = version(latest_luid(p))

# Initialization
function load_stdlibs()
    for (uuid, nv) in Pkg.Types.stdlibs()
        # this depends on julia version: 1.7 gives name only, 1.8 gives name and version
        name, version = nv isa Tuple ? nv : (nv, nothing)
        UUIDS_BY_NAME[name] = uuid
        v = version === nothing ? VERSION : version
        ENTRIES_BY_UUID[uuid] = Stdlib(name, v)
        push!(UUID_VERSION_BY_LUID, (uuid, v))
        LUID_BY_UUID_VERSION[(uuid, v)] = lastindex(UUID_VERSION_BY_LUID)
        LUID_BY_UUID[uuid] = lastindex(UUID_VERSION_BY_LUID):lastindex(UUID_VERSION_BY_LUID)
    end
end

function load_registry(r)
    for (uuid, pkg) in r.pkgs
        Pkg.Registry.init_package_info!(pkg)
        name = pkg.name
        UUIDS_BY_NAME[name] = uuid
        ENTRIES_BY_UUID[uuid] = pkg
        versions = sort!(collect(keys(pkg.info.version_info)))
        for v in versions
            push!(UUID_VERSION_BY_LUID, (uuid, v))
            LUID_BY_UUID_VERSION[(uuid, v)] = lastindex(UUID_VERSION_BY_LUID)
        end
        LUID_BY_UUID[uuid] = lastindex(UUID_VERSION_BY_LUID)-length(versions)+1:lastindex(UUID_VERSION_BY_LUID)
    end
end
function clear()
    empty!(UUIDS_BY_NAME)
    empty!(UUIDS_BY_NAME)
    empty!(ENTRIES_BY_UUID)

    empty!(UUID_VERSION_BY_LUID)
    empty!(LUID_BY_UUID_VERSION)

    empty!(LUID_BY_UUID)

    empty!(LUID_DEPENDENCY_GRAPH)
end
