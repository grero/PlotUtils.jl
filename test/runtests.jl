using PlotUtils
using AbstractPlotting
using Test


@testset "AxHSpan" begin
    scene = axhspan([1.0, 2.0])
    ll = AbstractPlotting.limits(scene)[]
    @test ll.widths ≈ [1.2, 1.2, 0.0]
    @test ll.origin ≈ [0.9, -0.1, 0.0]
end
