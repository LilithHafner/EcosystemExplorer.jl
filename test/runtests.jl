using EcosystemExplorer
using Test, UUIDs, DataFrames

@testset "EcosystemExplorer.jl" begin
    @test uuid("StatsBase") == UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")
    @test name(UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")) == "StatsBase"
    @test uuid(DataFrames) == UUID("a93c6f00-e57d-5684-b7b6-d8193f3e46c0")
    @test length(versions(DataFrames)) ≥ 55 # 55 on 2022-08-10

    @test downloads(DataFrames) > 1000 # 14257 on 2022-08-10
    @test downloads("ArrayAllez") < 100 # 0 on 2022-08-10

    @test length(dependencies(DataFrames, v"1.0.0")) == 11
    @test length(dependents(DataFrames)) ≥ 100 # 472 on 2022-08-10

    # Stdlibs
    @test uuid("Statistics") == UUID("10745b16-79ce-11e8-11f9-7d13ad32a3b2")
    @test name(UUID("10745b16-79ce-11e8-11f9-7d13ad32a3b2")) == "Statistics"
    @test latest_version(UUID("10745b16-79ce-11e8-11f9-7d13ad32a3b2")) isa VersionNumber
end
