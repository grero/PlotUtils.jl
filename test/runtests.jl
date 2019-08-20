using PlotUtils
using AbstractPlotting
using Test


@testset "AxHSpan" begin
    x = [0.205164, 0.599995, 0.911245, 0.0413585, 0.201556, 0.756409, 0.262528, 0.543553, 0.69455, 0.483662]
    y = [0.83071, 0.286859, 0.489174, 0.300569, 0.980194, 0.754755, 0.825237, 0.267783, 0.729878, 0.106738]
    scene = scatter(x, y)
    axhspan!(scene, [-0.1, 0.1])
    ll = AbstractPlotting.limits(scene)[]
    @test ll.widths ≈ [1.2134941f0, 1.2496823f0, 0.0f0]
    @test ll.origin ≈ [-0.2011245f0, -0.08137515f0, 0.0f0]
end
