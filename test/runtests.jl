using PackageGraphs
using Test, UUIDs

@testset "PackageGraphs.jl" begin
    @test uuid("StatsBase") == UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")
end
