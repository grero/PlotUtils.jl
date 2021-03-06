module PlotUtils
using SomeCoolColourMaps
using AbstractPlotting
import AbstractPlotting:plot!, Plot, default_theme, to_value, RGBA

@recipe(Wedges, θ, Δθ, origin, r) do scene
    Theme(colormap = cmap("C2"))
end

function AbstractPlotting.plot!(p::Wedges)
    origin = p[3][]
    θ = p[1][]
    Δθ = p[2][]
    r = p[4][]
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

@recipe(Plane, points) do scene
    Theme()
end

function AbstractPlotting.plot!(plot::Plane)
    points = plot[1]
    #define triangles
    tridx = [1,2,3,1,4,3]
    mesh!(plot,points, tridx)
end

@recipe(StackedBuckets, level, height) do scene
    Theme(colormap = cmap("C2"),
          vertical = true,
          xoffset = 0.0,
          yoffset = 0.0)
end

function AbstractPlotting.plot!(plot::StackedBuckets)
    bheight = plot[1][]
    blevel = plot[2][]
    vertical = plot[:vertical][]
    xoffset = plot[:xoffset][]
    yoffset = plot[:yoffset][]
    _cm = plot[:colormap][]
    colors = _cm[1:div(length(_cm),length(bheight)):length(_cm)]
    for (h,l,color) in zip(bheight, blevel,colors)
        if vertical
            Δh = Point2f0(1.0, h)
            Δl = Point2f0(1.0, l)
        else
            Δh = Point2f0(h, 1.0)
            Δl = Point2f0(l, 1.0)
        end
        rrh = FRect(Point2f0(xoffset, yoffset),Δh)
        rrl = FRect(Point2f0(xoffset, yoffset), Δl)
        poly!(plot, rrh, color=RGBA(0.2, 0.2, 0.2,0.0) + 0.8*color)
        poly!(plot, rrl, color=color)
        if vertical
            yoffset += h
        else
            xoffset += h
        end
    end
end

end # module
