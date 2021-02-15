# define a function that returns a Plots.Shape
function rectangle(w, h, x, y)

    return Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

end
