module PlotUtils
using SomeCoolColourMaps
using AbstractPlotting
import AbstractPlotting:plot!, Plot, default_theme, to_value


struct Wedges
    θ::Vector{Float32}
    Δθ::Float32
    origin::Point2f0
    r::Point2f0
end

function default_theme(scene::SceneLike, ::Type{<: Plot(Wedges)})
    Theme(colormap = cmap("C2"))
end

function AbstractPlotting.plot!(p::Plot(Wedges))
    wedges = to_value(p[1])
    origin = wedges.origin
    θ = wedges.θ
    Δθ = wedges.Δθ
    r = wedges.r
    polys = Vector{Point2f0}[]
    _cm = p[:colormap][]
    colors = _cm[1:div(length(_cm),length(θ)):length(_cm)]
    for i in 1:length(θ)
        pp = [Point2f0(origin[1] + r[1]*cos(ϕ), origin[2] + r[2]*sin(ϕ)) for ϕ in range(θ[i]- Δθ/2, stop=θ[i] + Δθ/2, length=20)]
        pp = [[origin];pp;[origin]]
        push!(polys, pp)
        poly!(p, pp, color=colors[i])
    end
end

@recipe(AxHSpan, x) do scene
    Theme(fill_color = :grey
         )
end

function AbstractPlotting.plot!(plot::AxHSpan)
    _limits = AbstractPlotting.limits(plot)
    x = plot[1]
    rr = map(_limits) do ll
        _x = x[]
        y0 = ll.origin[2]
        h = ll.widths[2]
        FRect(Point2f0(_x[1], y0), Point2f0(_x[2]-_x[1], h))
    end
    poly!(plot, rr, color=plot[:fill_color])
end

end # module
