```@meta
EditURL = "script/visualize_residuals.jl"
```

# Visualization of residual vectors on the Bloch sphere
Residual vector: |ϕ> = H|ψ> - <ψ|H|ψ>|ψ>
Velocity vector on the Bloch sphere corresponding to |ϕ>: d/dt r = <ϕ|σ|ψ>
We visualize the residual vector on the Bloch sphere using Makie.jl

````@example visualize_residuals
using BlochSpins
using Zygote
using StaticArrays, LinearAlgebra
using WGLMakie
WGLMakie.activate!()
````

# Definition of helper functions
when you consider $\frac{\partial}{\partial t} |\psi\rangle = \phi$ at spacie of Bloch sphere,
direction vector on Bloch sphere will be $\frac{\partial}{\partial t} \vec{r} = \langle \phi | \vec{\sigma} | \psi \rangle$

````@example visualize_residuals
function velocity_vector(ψ, ϕ)
    x = ϕ' * σx * ψ
    y = ϕ' * σy * ψ
    z = ϕ' * σz * ψ
    return SVector(x, y, z)
end
````

point on Bloch sphere can be spacified by (θ, ϕ)

````@example visualize_residuals
function bloch_ket(θ, ϕ)
    c = cos(θ / 2) + 0im
    s = exp(im * ϕ) * sin(θ / 2)
    return Ket(SVector{2,ComplexF64}(c, s))
end
````

compute norm of gradient of energy expectation value w.r.t. (θ, ϕ)

````@example visualize_residuals
function gradient_norm(θ, ϕ, H_data)
    ψ = bloch_ket(θ, ϕ)
````

エネルギー期待値の勾配 (残差ベクトル |ϕ> の定数倍)

````@example visualize_residuals
    grad_vec = Zygote.gradient(v -> real(adjoint(v) * H_data * v), ψ.v)[1]
    return norm(grad_vec)
end
````

--- definition of parameters ---

````@example visualize_residuals
n = normalize(SVector(1, 1, 1))
H = H_Zeeman(1.0, n)
ψ = k_up
ϕ = H * ψ - expect(H, ψ) * ψ
````

--- init figure ---

````@example visualize_residuals
fig, ax = init_figure()
visualize_bloch_sphere!(fig, ax)
visualize_axis!(fig, ax)
arrows3d!(
    ax,
    [Point3f(0)],
    [Point3f(n...)];
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:red,
    transparency=true,
)
text!(ax, "B1"; position=Point3f((n * 1.1)...), color=:red)
````

--- draw initial state ---

````@example visualize_residuals
init_state = Point3f(real.(bloch_vector(ψ))...)
arrows3d!(
    ax,
    [Point3f(0)],
    init_state;
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:orange,
    transparency=true,
)
````

--- calculate residual ---
The residual vector points in the direction of increasing energy.
To rotate the spin toward the ground state, we need to apply $-i$.

````@example visualize_residuals
ψ = normalize(ψ)
Residual = H * ψ - expect(H, ψ) * ψ
v_fwd = Point3f(real.(velocity_vector(ψ, Residual))...)
arrows3d!(
    ax,
    init_state,
    v_fwd;
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:orange,
    transparency=true,
)
text!(ax, "Residual Vector"; position=Point3f(((v_fwd + init_state) * 1.1)...), color=:red)
````

--- residual * imaginary unit ---
if you apply -i factor to the residual vector, it corresponds to the velocity vector on the Bloch sphere. you can see it by constructing time evolution operator.

````@example visualize_residuals
Residual = -im * Residual
v_fwd = Point3f(real.(velocity_vector(ψ, Residual))...)
arrows3d!(
    ax,
    init_state,
    v_fwd;
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:orange,
    transparency=true,
)
text!(ax, "-im * Residual"; position=Point3f(((v_fwd + init_state) * 1.1)...), color=:red)

display(fig)
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

