using EcosystemExplorer
using Test, UUIDs, DataFrames

@testset "EcosystemExplorer.jl" begin
    @test uuid("StatsBase") == UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")
    @test name(UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")) == "StatsBase"
    @test uuid(DataFrames) == UUID("a93c6f00-e57d-5684-b7b6-d8193f3e46c0")

    @test downloads(DataFrames) > 1000 # 14257 on 2022-08-10
    @test downloads("ArrayAllez") < 100 # 0 on 2022-08-10

    @test length(dependencies(DataFrames, v"1.0.0")) == 11
    @test length(dependents(DataFrames)) ≥ 100 # 472 on 2022-08-10
end
