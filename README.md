# EcosystemExplorer

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LilithHafner.github.io/EcosystemExplorer.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LilithHafner.github.io/EcosystemExplorer.jl/dev/)
[![Build Status](https://github.com/LilithHafner/EcosystemExplorer.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LilithHafner/EcosystemExplorer.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LilithHafner/EcosystemExplorer.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/EcosystemExplorer.jl)

This package aims to provide all the simple tools you need to dig into the julia package
ecosystem. See also https://github.com/JuliaEcosystem for alternatives.

# Features

It provides a summary data frame.
```julia
pkg> add https://github.com/LilithHafner/EcosystemExplorer.jl
[...]

julia> using EcosystemExplorer

julia> EcosystemExplorer.summary()
8099×6 DataFrame
  Row │ name              version    downloads  dependencies      dependents        uuid
      │ String            VersionN…  Int64      Array…            Array…            Base.UUID
──────┼──────────────────────────────────────────────────────────────────────────────────────────────
    1 │ MbedTLS           1.1.3          38822  ["MbedTLS_jll",…  ["MbedTLS_jll",…  739be429-bea8-5…
    2 │ ChainRulesCore    1.15.3         36850  ["Compat"]        ["Compat"]        d360d2e6-b24c-1…
    3 │ StaticArrays      1.5.2          36394  ["StaticArraysC…  ["StaticArraysC…  90137ffa-7385-5…
    4 │ StatsBase         0.33.21        36110  ["Missings", "S…  ["Missings", "S…  2913bbd2-ae8a-5…
    5 │ Parsers           2.3.2          35300  String[]          String[]          69de0a69-1ddd-5…
    6 │ LogExpFunctions   0.3.17         33457  ["ChainRulesCor…  ["ChainRulesCor…  2ab3a3ac-af41-5…
    7 │ Compat            4.1.0          32929  String[]          String[]          34da2185-b29b-5…
    8 │ SpecialFunctions  2.1.7          30799  ["LogExpFunctio…  ["LogExpFunctio…  276daf66-3868-5…
    9 │ ChangesOfVariab…  0.1.4          30637  ["ChainRulesCor…  ["ChainRulesCor…  9e997f8a-9a97-4…
  ⋮   │        ⋮              ⋮          ⋮             ⋮                 ⋮                 ⋮
 8091 │ EntityComponent…  0.0.1              0  String[]          String[]          a8343a65-b356-5…
 8092 │ HeuristicOptimi…  0.0.1              0  String[]          String[]          de832154-0e71-4…
 8093 │ Hygienic          0.0.1              0  String[]          String[]          60a53d29-03fa-4…
 8094 │ MarkableIntegers  0.0.1              0  String[]          String[]          0913cafa-90c8-5…
 8095 │ NumberUnions      0.0.1              0  String[]          String[]          fe510250-cf29-5…
 8096 │ OBOParse          0.0.1              0  String[]          String[]          afb48802-0cf5-5…
 8097 │ RTLSDR            0.0.1              0  String[]          String[]          71cfaeeb-f3e6-5…
 8098 │ RobotDescriptio…  0.0.1              0  String[]          String[]          498c179e-6d39-5…
 8099 │ Sabermetrics      0.0.1              0  String[]          String[]          415736d3-e371-4…
                                                                                    8081 rows omitted
```

And also a set of "do what I mean" conversion functions and accessors
```julia
julia> uuid("StatsBase")
UUID("2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91")

julia> name("9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0")
"ChangesOfVariables"

julia> latest_version("GLMakie")
v"0.6.13"

julia> x = rand(package_names())
"DataEnvelopmentAnalysis"

julia> downloads(x)
15

julia> dependencies(x)
6-element Vector{Pair{String, Vector{VersionNumber}}}:
 "InvertedIndices" => [v"1.1.0"]
            "GLPK" => [v"0.14.0", v"0.14.1", v"0.14.2", v"0.14.3"  …  v"0.15.2", v"0.15.3", v"1.0.0", v"1.0.1"]
           "Ipopt" => [v"0.6.5", v"0.7.0", v"0.8.0", v"0.9.0", v"0.9.1", v"1.0.0", v"1.0.1", v"1.0.2", v"1.0.3"]
   "ProgressMeter" => [v"1.7.0", v"1.7.1", v"1.7.2"]
            "JuMP" => [v"0.21.0", v"0.21.1", v"0.21.2", v"0.21.3"  …  v"0.23.2", v"1.0.0", v"1.1.0", v"1.1.1"]
       "StatsBase" => [v"0.33.0", v"0.33.1", v"0.33.2", v"0.33.3"  …  v"0.33.18", v"0.33.19", v"0.33.20", v"0.33.21"]

julia> dependents(x)
1-element Vector{String}:
 "BenchmarkingEconomicEfficiency"
```

You can also get a list of all exported symbols with and without docstrings
```julia
julia> docstrings("DataEnvelopmentAnalysis") # takes a long time to run the first time
┌ Warning: DataEnvelopmentAnalysis exports DEAModel but it is not defined
└ @ EcosystemExplorer ~/.julia/dev/EcosystemExplorer/src/docstrings.jl:43
┌ Warning: DataEnvelopmentAnalysis exports TechnicalDEAModel but it is not defined
└ @ EcosystemExplorer ~/.julia/dev/EcosystemExplorer/src/docstrings.jl:43
([:AbstractCostDEAModel, :AbstractDEAModel, :AbstractDEAPeers, :AbstractDEAPeersDMU, :AbstractEconomicDEAModel, :AbstractHolderDEAModel, :AbstractProductivityDEAModel, :AbstractProfitDEAModel, :AbstractProfitabilityDEAModel, :AbstractRadialDEAModel  …  :nobs, :normfactor, :noutputs, :nperiods, :peers, :peersmatrix, :prodchange, :rts, :slacks, :targets], [:DEAModel, :DataEnvelopmentAnalysis, :TechnicalDEAModel, :deamaxprofit, :deamaxrevenue, :deamincost])
```
