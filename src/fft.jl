"""
    Funciones necesarias para FFT, calculado en una notación matricial:

    fft_matrices: crea la matriz E usando H y N (numero de coeficientes del desarrollo de Fourier retenidos y puntos en los que se evalua la funcion respectivamente).

    system_matrix: Define una matriz A de la forma en que el problema algebraico no lineal obtenido de hacer la transformada de Fourier tiene la forma: [A][x̂]+[ĝ] = [f̂₀]
"""

function fft_matrices(N, H)
    E = zeros(N, 2H + 1)
    E[:, 1] .= 1 / 2
    for h in 1:H
        E[:, 2h] = cos.(2π / N * (0:(N - 1)) * h)
        E[:, 2h + 1] = sin.(2π / N * (0:(N - 1)) * h)
    end

    Eᴴ = copy(E')
    Eᴴ[1, :] .= 1
    Eᴴ *= 2 / N
    return E, Eᴴ
end


function system_matrix(H::Int, ξ::Real, Ω::Real)
    # para A mismo tipo que Ω
    A = zeros(eltype(Ω), 2H, 2H)

    for k in 1:H
        A[(2k - 1):(2k), (2k - 1):(2k)] .= [(1 - k^2 * Ω^2)  k*Ω*ξ;
                                            -k*Ω*ξ  (1-k^2 * Ω^2)]
    end
    return A
end

"Ejemplo de uso:"

N=100
H=2
t = range(0, 2π, length=N)
    for i ∈ eachindex(t)
    println(t[i])
    end

#y = 2sin.(t) + sin.(2t) - cos.(t)
y = 5*ones(length(t))


#Plot de la curva en el dominio temporal
using GLMakie
begin
    f = Figure()
    ax = Axis(f[1,1])
    lines!(ax, t, y)
    f
end


E, Eᴴ = fft_matrices(N, H)
Y = Eᴴ*y
#Plot de los coeficientes de Fourier
ϵ = 1e-1
begin
f2 = Figure()
ax = Axis(f2[1,1], limits=(-ϵ, 2H+ϵ, -3, 3))
stem!(ax, LinRange(0, 2H, 2H+1), Y)
f2
end
