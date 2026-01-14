using BlochSpins
using StaticArrays, LinearAlgebra
using CairoMakie

n1 = normalize(SVector(1, 1, 1))
n2 = normalize(SVector(1, 1, -1))
H(B::Float64, n::SVector) = -B * sum(n .* σ)

# prepare figure
CairoMakie.activate!()
fig, ax = init_figure()
visualize_bloch_sphere!(fig, ax)
visualize_axis!(fig, ax)

# 磁場の向き
arrows3d!(
    ax,
    [Point3f(0)],
    [Point3f(n1...)];
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:red,
    transparency=true,
    label="0-t1",
)
arrows3d!(
    ax,
    [Point3f(0)],
    [Point3f(n2...)];
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:cyan,
    transparency=true,
    label="t1-t2",
)
text!(ax, "B1"; position=Point3f((n1 * 1.1)...), color=:red)
text!(ax, "B2"; position=Point3f((n2 * 1.1)...), color=:cyan)

# forward direction: |up> state
traj_fwd = Observable(Point3f[real.(bloch_vector(k_up))])
vec_fwd = Observable([Point3f(real.(bloch_vector(k_up))...)])
lines!(ax, traj_fwd; color=:orange, linewidth=3, label="Forward (|0⟩)")
arrows3d!(
    ax,
    [Point3f(0)],
    vec_fwd;
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:orange,
    transparency=true,
)

# backward direction: |down> state
traj_bwd = Observable(Point3f[real.(bloch_vector(k_down))])
vec_bwd = Observable([Point3f(real.(bloch_vector(k_down))...)])
lines!(ax, traj_bwd; color=:dodgerblue, linewidth=3, label="Backward (|1⟩)")
arrows3d!(
    ax,
    [Point3f(0)],
    vec_bwd;
    tipradius=0.04,
    tiplength=0.08,
    shaftradius=0.007,
    color=:dodgerblue,
    transparency=true,
)

# record
times = 0:0.05:2π
B = 1.0
H1 = H(B, n1)
H2 = H(B, n2)
record(fig, "bloch_trajectory.gif", times; framerate=20) do t
    psi_fwd = Ket(exp(-1im * H1.data * t) * k_up.v)
    v_fwd = Point3f(real.(bloch_vector(psi_fwd))...)

    # 逆方向: exp(+i * H2 * t) |down>  (逆回し)
    psi_bwd = Ket(exp(1im * H2.data * t) * k_down.v)
    v_bwd = Point3f(real.(bloch_vector(psi_bwd))...)
    if norm(v_bwd - v_fwd) < 1e-2
        println("States meet at t = $t")
        @show bloch_vector(psi_fwd)
        @show bloch_vector(psi_bwd)
    end
    # Observable更新
    push!(traj_fwd[], v_fwd);
    notify(traj_fwd)
    push!(traj_bwd[], v_bwd);
    notify(traj_bwd)
    vec_fwd[] = [v_fwd]
    vec_bwd[] = [v_bwd]

    az = 0.5π + 0.5 * sin(0.5 * t) # 方位角
    el = 0.1π + 0.2 * cos(0.5 * t) # 仰角
    r = 5 # 視点距離

    eyepos = Point3f(r * cos(el) * cos(az), r * cos(el) * sin(az), r * sin(el))
    update_cam!(ax.scene, eyepos, Point3f(0, 0, 0))
end
