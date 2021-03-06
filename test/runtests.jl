using PlotUtils
using AbstractPlotting
import AbstractPlotting: Point2f0, RGBA
using Test

@testset "Wedges" begin
    θ = range(-pi, stop=pi, length=10)
    Δθ = step(θ)
    scene = wedges(θ, Δθ, Point2f0(0.0, 0.0), Point2f0(1.0, 1.0))
    @test scene.plots[2].plots[1].color[] ≈ RGBA{Float64}(0.9531719984702666,0.3073822792529262,0.965837667236174,1.0)
    @test scene.plots[2].plots[1][1][][1][1] ≈ Point2f0(0.0)
    @test scene.plots[2].plots[1][1][][1][end] ≈ Point2f0(-0.939693, -0.34202) 

    ll = AbstractPlotting.limits(scene)[]
    @test ll.origin ≈ Point3f0(-1.1998143f0, -1.1999409f0, 0.0f0)
    @test ll.widths ≈ Point3f0(2.3997974f0, 2.3998818f0, 0.0f0)

end

@testset "AxHSpan" begin
    scene = axhspan([1.0, 2.0])
    ll = AbstractPlotting.limits(scene)[]
    @test ll.widths ≈ [1.2, 1.2, 0.0]
    @test ll.origin ≈ [0.9, -0.1, 0.0]
end

@testset "Plane" begin
    points = [Point3f0(-1.0, -1.0, -1.0), Point3f0(-1.0, 1.0, -1.0), Point3f0(1.0, 1.0, 1.0), Point3f0(1.0, -1.0, 1.0)]
    scene = plane(points)
    @test scene.plots[2].plots[1][1][].vertices ≈ Point{3,Float32}[[-1.0, -1.0, -1.0], [-1.0, 1.0, -1.0], [1.0, 1.0, 1.0], [1.0, -1.0, 1.0]]
    @test scene.plots[2].plots[1][1][].normals[2] ≈ Float32[0.707107, 0.0, -0.707107]
    @test scene.plots[2].plots[1][1][].normals[4] ≈  Float32[-0.707107, 0.0, 0.707107]
end

@testset "StackedBuckets" begin
    h = 10*rand(4)
    l = rand(4).*h
    scene = stackedbuckets(h,l)
    @test scene.plots[2].plots[1][1][][1][3] ≈ Point2f0(1.0, h[1])
    @test scene.plots[2].plots[2][1][][1][3] ≈ Point2f0(1.0, l[1])
    @test scene.plots[2].plots[3][1][][1][3] ≈ Point2f0(1.0, h[1] + h[2])
    @test scene.plots[2].plots[4][1][][1][3] ≈ Point2f0(1.0, h[1] + l[2])
    scene = stackedbuckets(h,l, vertical=false)
    @test scene.plots[2].plots[1][1][][1][3] ≈ Point2f0(h[1], 1.0)
    @test scene.plots[2].plots[2][1][][1][3] ≈ Point2f0(l[1], 1.0)
    @test scene.plots[2].plots[3][1][][1][3] ≈ Point2f0(h[1] + h[2], 1.0)
    @test scene.plots[2].plots[4][1][][1][3] ≈ Point2f0(h[1] + l[2], 1.0)
    h = 10*rand(4)
    l = rand(4).*h
    scene = stackedbuckets(h,l)
    h = 10*rand(4)
    l = rand(4).*h
    stackedbuckets!(scene, h,l, xoffset=1.5)
    @test scene.plots[3].plots[1][1][][1][3] ≈ Point2f0(2.5, h[1])

end
